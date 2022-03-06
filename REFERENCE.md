# Full Reference - yviel's FSA `v0.1.0`
This page contains the list of configuration keys and FSA behavior.

See the [Examples](EXAMPLES.md) for simple practical applications.

 - [Context](#)
    - [Definitions](#definitions)
    - [Implicit defaults](#implicit-defaults)
    - [Comments](#comments)
 - [base](#base)
 - [net](#net)
 - [web](#web)
 - [virt](#virt)
 - [mail](#mail)
 - [apps](#apps)

#### Definitions
Keys which are required when their parent is set are marked with `REQ`. I probably forgot a couple, please open bug tickets.

Defaults are indicated either by their non-example value or in the comment.

#### Implicit defaults
Occasionally you will find expressions like these:
```
key: true
  subkey: value
```
This is an invalid construct, and the `key`'s value is only indicated to show its default value.
It must be unset (eg default) for the `subkey` to work.
The above construct can be either
```
key: false
```
or
```
key:                # unset = default value
  subkey: value
```
#### Comments
Note that the kind of comments displayed on this page are *not* supported.
Comments may be used on individual lines, at any indentation level, like such:
```
key: value
# comment
  subkey: value
```

## `base`
The only *required* settings. In addition to `name` and `user`, **either `userpw` or `nopass` must be set**.

Run `fsa genpass [mypassword]` against the host to generate hashes (and passwords).

Note that if the user or root passwords aren't indicated here, any existing ones be removed by FSA.

Config keys selectively executable through `-c`/`-t`:
`base`, `sshd`, `cron`
```
base:
  name: host.example.com            # REQ: the machine's fqdn
  user: name                        # REQ: the user to set up
  nopass: false                     # nopass-sudo/doas for the user
  userpw: crypted value             # user's password hash - use fsa genpass
                                    # REQ: either userpw or nopass
  rootpw: crypted value             # root password hash - use fsa genpass
  sound: false                      # enable sound
  mailto: hostmaster@example.com    # mail recipient for root@localhost
  autoupdate: true                  # daily auto-update anytime between 00-01h
  sshd:
    enabled: true                   # enable sshd
    guard: false                    # enable sshguard
    tune: true                      # set strong ssh algos
  cron:
    - "MAILTO=hostmaster@example.com"
    - "0 0 * * * someuser echo example"
```

## `net`
Basic networking, routing, DHCP/DNS, VPN and Firewalling.

VPN requires both hosts to be managed by ansible, and has different keywords depending on client/server role, marked with `SRV` and `CLN`

Config keys selectively executable through `-c`/`-t`:
`net`, `ifaces`, `dhcp`, `dns`, `vpn`, `fw`
```
net:
  routing: false
  public: false                             # block bad actors using spamhaus, firehol etc
  routes:									# example values
    - default 192.168.0.1
    - 10.0.0.1/24 192.168.0.232
  ifaces:									# REQ
    - name: eth0                            # REQ: use fsa -f -l myhostname to display ifaces
    - name: vlan4                           # VLAN interface example
      vlanid: 4
      parent: eth0
      addr: 10.0.0.123	                    # static address and netmask, omit for dhcp
      netmask: 255.255.255.0                # REQuired for some things
      dhcp:                                 # enable dhcp server on this iface
        - range: 10.0.0.128 10.0.0.254      # example range
          domain: example.com               # required for dns autoregister, see leases
          routers: 10.0.0.1, 10.0.0.2       # default: self
          dnssrv: 10.0.0.1, 10.0.0.2        # default: self
          lease_time: 3600                  # max lease limit in seconds, default ~24h
          deny_unknown: false               # deny clients not explicitly leased
          leases:
            - name: myhost
              ip: 10.0.0.212
              mac: 00:00:de:ad:be:ef
              dns: true                     # autoregister with dns server
  dns:
    filter: true                            # block ads at the dns level
      whitelist:                            # if filter is unset(=true),
        - analytics.google.com              # domains to exempt from blocking
        - "*.doubleclick.net"
    listen:                                 # interfaces to listen on
      - 0.0.0.0                             # default 127.0.0.1
    access:                                 # access rules
      - 0.0.0.0/0 refuse                    # these 2 are always set & just an example
      - 127.0.0.0/8 allow
    localzone: examplenet.local.            # unique local DNS zone
    localdata:                              # arbitrary local DNS data
      - myhost.example.com. IN A 192.168.0.212
      - something.thing.local IN TXT "my beautiful string"
    forward:                                # forward queries elsewhere instead of resolving
      tls: false                            # forward with tls
      addr:                                 # whom to forward to
        - 9.9.9.9
        - 149.112.112.112
  vpn:
    type: wireguard
    iface: eth0                             # REQ: interface to use for the connection
    addr: 10.0.0.1                          # REQ: own internal VPN IP
    port: 51820                             # SRV: external port to listen on (51820)
    psk: false                              # use a psk
    persist: false                          # watchdog the connection
    peers:                                  ## SRV: REQ
      - name: kane                          # REQ: must be listed in the inventory
        addr: 10.0.0.2                      # REQ: client's internal VPN IP
        keepalive: 32                       # interval in seconds (default none)
    peer:                                   ## CLN: REQ, only 1 srv
      name: cabal                           # REQ: must be listed in the inventory
      addr: 192.168.0.123                   # REQ: server address or hostname
      port: 51820                           # server port (51820)
      keepalive: 32                         # interval in seconds (default none)
  fw:
    rules:
      - act: block                          # REQ: pass/block
        dir: out                            # REQ: direction from the fw's pov
        iface: wg0
        proto: tcp
        from: 100.64.0.1                    # negate like !this
        to: "!192.168.0.128/30"             # negate like !this
        port: 12345
        rdrto: 192.168.0.122                # redirect to
        rdrport: 54321                      # redirectport
        natto: 192.168.0.122
```

## `web`
Webserver, SSL/TLS, PHP, Relay/LB.

In virtually every case a generic LE-handling catchall HTTPD with SSL redirect will be set up on port 80.

Config keys selectively executable through `-c`/`-t`:
`web`, `httpd`, `sites`, `auth`, `relay`
```
web:
  httpd: false
    auth:                       # htpasswd, valid for all sites
      - name: myuser
        pass: mypass            # cleartext
    php:                        # default false
      version: 8.0              # REQ
      libs:                     # example values
        - zip
        - pdo_sqlite
  sites:
    - name: example.com         # REQ: domain name
      listen: all               # iface name or ip
      root: /test.example
      alts:                     # domain aliases
        - sub.example.com
        - other.example.com
      index: example.html       # index page
      tls: false                # ssl [false|dev|prod]
      php: false

  relay:                        # relay & filter connections, example values
    frontends:                  # REQ: frontends to accept connections on
      - name: httpfront         # REQ
        type: http              # REQ: type (http/tcp/dns)
        port: 443               # REQ
        addr: 0.0.0.0
        tls: prod
        wsock: false            # websockets (http type only)
    backends:                   # REQ: backends to route connections to
      - name: httpback          # REQ: name
        port: 80                # REQ: target port
        front: httpfront        # REQ: frontend to take connections from
        domains:                # route by requested domain (http type only)
          - my.domain.com
          - other.domain.com
        sources:                # route by source IP
          - 127.0.0.1
          - 192.168.0.1/24
        targets:                # REQ: targets to route to
          - web1.example.com    # and balance between
          - web2.example.com
        check:                  # life-check targets
          type: http            # type [http/tcp]
          path: /example.txt
          code: 200             # path & code http only
```

## `virt`
Hypervisor for running VMs.

Config keys selectively executable through `-c`/`-t`:
`virt`
```
virt:
  bridge: bse0                  # REQ: interface to bind to
  vms:
    - name: myvm                # REQ: name of the vm
      mem: 2G                   # REQ: ram
      size: 10G                 # REQ: disk size
      mac: 00:de:ad:be:ef:00    # mac addr
      iso: /path/to/file.iso    # as file in /home/isos/ or absolute path
      install: openbsd          # OS installdisk to build and mount [openbsd/debian/alpine]
      autostart: true           # whether to autostart on boot
```

## `mail`
Mail server or gateway with spam filtering, dkim, etc.

Config keys selectively executable through `-c`/`-t`:
`mail`, `listen`, `domains`, `boxes`, `users`, `virtuals`, `whitelist`, `setup`
```
mail:
  setup: true                       # print required DNS records
  listen:                           # REQ
    - addr: all                     # REQ: addresses to listen on
      port: 25                      # REQ: listen port
      auth: true                    # require auth
      tls: false                    # [false/true/force]
      dkim: false
      filter: false                 # [false/true/spam]
      whitelist: false
      name: mail.example.com        # override HELO hostname
  domains:
    - example.com
    - mydomain.net
  boxes:
    - addr: user@example.com
      pass: <crypted value>         # use ./genpass.sh [pass]
    - addr: test@example.com
      pass: <crypted value>
  users:                            # gateway/relay users
    - name: someuser
      pass: <crypted value>         # use ./genpass.sh [pass]
  virtuals:                         # redirections, aliases, expansions etc
    - "alias@example.com    user@example.com"
    - "list@example.com     user@example.com user@domain.com other@more.org"
    - "@mydomain.net        test@example.com"
  whitelist:                        # IPs for the whitelist
    - 192.168.0.22
    - 192.168.0.23
```

## `apps`
Miscellaneous useful applications.

Config keys selectively executable through `-c`/`-t`:
`apps`, `dav`
```
apps:
  dav:
    site: dav.mydomain.net		# REQ: matching web.site with PHP
    admin:
      - user: adminuser
        pass: adminpass			# REQ: in cleartext
```

