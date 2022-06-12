# Roles - yviel's FSA v0.2.0
Roles are the individual building blocks of FSA, each providing a different functionality.

They can be individually addressed using the `-r` or `--role` [fsa switch](docs/FSA_CMD.md).

This is a collection of more complex usage examples involving multiple roles.

For smaller examples view the individual role pages, for the full reference [go here](docs/REFERENCE.md)

## Table of Contents
 - [DNS+DHCP Server + VPN Gateway](#dns+dhcp-server-+-vpn-gateway)
    - [Description](#description)
    - [Roles used](#roles-used)
    - [Configuration](#configuration)
 - [Full Mail Solution](#full-mail-solution)
    - [Description](#description)
    - [Roles used](#roles-used)
    - [Configuration](#configuration)
 - [Site2Site VPN + Loadbalancer + Webserver](#site2site-vpn-+-loadbalancer-+-webserver)
    - [Description](#description)
    - [Roles used](#roles-used)
    - [Configuration](#configuration)
 - [LAMP Stack](#lamp-stack)
    - [Description](#description)
    - [Roles used](#roles-used)
    - [Configuration](#configuration)
 - [Hypervisor + VM autoinstall](#hypervisor-+-vm-autoinstall)
    - [Description](#description)
    - [Roles used](#roles-used)
    - [Configuration](#configuration)

## DNS+DHCP Server + VPN Gateway
#### Description
This allows you to provide automagic adblock and VPN to any device on your network.

Some of this is usually done by your home-router - you'll have to manually turn off DHCP in its WebUI.

#### Roles used
 - [net](net/)
 - [dhcp](dhcp/)
 - [dns](dns/)
 - [vpn](vpn/)

#### Configuration
```yaml
# my_local_server
net:
  # we enable routing so that we start forwarding other devices' packets for them
  routing: true
  # we set the default route to be our remote vpn endpoint
  routes:
    - default 172.16.0.1
  ifaces:
    # dhcp server requires static interface configuration
    # this assumes a regular home network with the router at 192.168.0.1/24
    - name: eth0
      addr: 192.168.0.2
      netmask: 255.255.255.0
      # we enable the dhcp server for this interface
      dhcp:
        # the range in which to hand out ips
        - range: 192.168.0.16 192.168.0.192
          domain: home.myname.local
          # clients in this range will send their traffic to the router
          routers: 192.168.0.1
          # we will answer their dns queries (and adblock them)
          dnssrv: 192.168.0.2
        - range: 192.168.0.193 192.168.0.254
          domain: vpn.myname.local
          # clients in this range wil send their traffic to us
          routers: 192.168.0.2
          # we're resolving the dns queries for both ranges here
          dnssrv: 192.168.0.2
          # here we're denying unknown clients and specifying what should go through us ie VPN
          deny_unknown: true
          # and finally, our privileged clients for whom we VPN things
          leases:
            - name: myvpnclient
              ip: 192.168.0.200
              mac: 00:de:ad:be:ef:00
  dns:
    # we enable the dns server to listen on all
    # it adblocks by default
    listen:
      - 0.0.0.0
  vpn:
    # we set up a vpn connection to a fsa-managed vpn server
    type: wireguard
    # interface to use for the vpn traffic
    iface: eth0
    # address inside the vpn network
    addr: 172.16.0.2
    # keepalive since it's our default route
    keepalive: 20
    peer:
      # name of the vpn server (must be existing fsa host)
      name: myvpnserver
      # ip address of the vpn server
      addr: 93.184.216.34
```
```yaml
# my_vpn_server
net:
  # this guy also needs to forward our packets
  routing: true
  vpn:
    # the server-side configuration for this
    type: wireguard
    iface: eth0
    # vpn-internal ip
    addr: 172.16.0.1
    peers:
    # this is our local client
      - name: mylocalserver
        # with its vpn-internal ip
        addr: 172.16.0.2
```

## Full Mail Solution
#### Description
This is a full email server with spam filtering, DKIM message signing, etc.

The run will output DNS records for you to set up before it works.

The target machine must have a public IP.

#### Roles used
 - [smtpd](smtpd/)
 - [boxes](boxes/)
 - [dkim](dkim/)
 - [filter](filter/)

#### Configuration
```yaml
mail:
  # output the DNS records necessary for the setup to function
  setup: true
  listen:
    # this is where we get mail from the outside world
    - addr: all
      # regular smtp port
      port: 25
      # true, but not force
      tls: true
      # filter aggressively
      filter: spam
    # and this is where our clients will send mail to
    - addr: all
      # smtp submission port
      port: 587
      # force tls
      tls: force
      # require auth
      auth: true
      # no filtering required
      filter: false
  domains:
    # the domains this server is responsible for
    - example.com
    - mydomain.net
  boxes:
    # the mailboxes to set up
    - addr: myuser@example.com
      # use `fsa -g` to generate hashes
      pass: $2b$08$tH5DkCLGPT2mProHcPR9KeseVgnN2L/oD83vpVUMkMMTrRaE0HPVO
    - addr: seconduser@example.com
      pass: $2b$08$tH5DkCLGPT2mProHcPR9KeseVgnN2L/oD83vpVUMkMMTrRaE0HPVO
  virtuals:
    # this is a simple mailbox alias
    - alias@example.com myuser@example.com
    # wildcard accepted
    - @mydomain.net myuser@example.com
    # this is a mailing list
    - list@example.com myuser@example.com external@user.org some@address.net
```

## Site2Site VPN + Loadbalancer + Webserver
#### Description
This setup allows you to make your local server reachable from the outside, for things you don't want to store on a VPS.

It uses Gitea as an example application, but can be virtually anything.

#### Roles used
 - [vpn](vpn/)
 - [relay](relay/)
 - [gitea](gitea/)

#### Configuration
```yaml
# my_local_server
net:
  vpn:
    # we set up a vpn connection to a fsa-managed vpn server
    type: wireguard
    # interface to use for the vpn traffic
    iface: eth0
    # address inside the vpn network
    addr: 172.16.0.2
    # we need a low keepalive since connections are coming *from* it
    keepalive: 1
    # and we want to autorestart the connection if it fails
    persist: true
    peer:
      # name of the vpn server (must be existing fsa host)
      name: myvpnserver
      # ip address of the vpn server
      addr: 93.184.216.34

apps:
  gitea:
    # gitea used as an example application
    # SSL is terminated by the LB in this scenario
    config:
      - section:
        option: APP_NAME
        value: My Gitea Server
```
```yaml
# my_vpn_server
net:
  # we're blocking any malicious actors here
  public: true
  # this guy also needs to forward our packets
  routing: true
  vpn:
    # the server-side configuration for this
    type: wireguard
    iface: eth0
    # vpn-internal ip
    addr: 172.16.0.1
    # here too low keepalive
    keepalive: 1
    # and autorestart on fail
    persist: true
    peers:
    # this is our local client
      - name: mylocalserver
        # with its vpn-internal ip
        addr: 172.16.0.2

web:
  relay:
    # we configure the loadbalancer
    frontends:
      # accept connections
      - name: tlsfrontend
        # can be http, tcp or dns
        type: http
        # our listen port
        port: 443
        # listen on all ifaces
        addr: 0.0.0.0
        # we want a real ssl cert
        tls: prod
    backends:
      # send connections to
      - name: vpnclient
        # name of the frontend origin
        origin: tlsfrontend
        # gitea webui runs on 8080
        port: 8080
        # required for tls. only this will be routed through
        domains:
          - gitea.mydomain.net
	    check:
          # health-check the backend before sending traffic to it
          type: http
          # path to check
          path: /favicon.ico
          # return code to expect
          code: 200
```

## LAMP Stack
#### Description
Set up the classic Webserver-PHP-MySQL stack.

#### Roles used
 - [httpd](httpd/)
 - [php](php/)
 - [mysql](mysql/)

#### Configuration
```yaml
web:
  # we enable the webserver
  httpd:
    php:
      # php version to install
      version: 8.4
      # additional php libs to install
      libs:
        - pdo_mysqli
  sites:
    - name: mydomain.net
      # aliases for the vhost
      alts:
        - www.mydomain.net
      # docroot, relative to /var/Www
      root: /mydomain_net
      # activate php for the site
      php: true
      # give us a letsencrypt-staging cert
      tls: dev
apps:
  # set up a mysql server
  mysql:
    # set up a database
    dbs:
      - mydatabase
    # and a user for it
    users:
      - name: myuser
        pass: mypassword
        on: mydatabase
```

## Hypervisor + VM autoinstall
#### Description
Automatically create virtual machines, and install an OS on them.

#### Roles used
 - [virt](virt/)
 - [vms](vms/)
 - [iso](iso/)
 - [install](install/)

#### Configuration
```yaml
virt:
  # the interface our VMs will be bound to
  bridge: eth0
  vms:
    - mybsdvm
      # RAM size
      mem: 512M
      # disk size
      size: 5G
      # auto-install an OS
      install:
        os: openbsd
        # timezone
        time: Canada/Mountain
        # pubkey for the root user
        key: ~/.ssh/id_rsa.pub
    - myalpinevm
      mem: 512M
      size: 5G
      install:
        os: alpine
        time: Canada/Mountain
        # keyboard layout, required for alpine
        layout: us
        key: ~/.ssh/id_rsa.pub
```
