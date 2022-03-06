# Examples - yviel's FSA `v0.1.0`
These are examples for configuration you can do with FSA.

See the [Reference](REFERENCE.md) for a full list of options.

 - [Examples: LAN](#examples-lan)
    - [DNS Resolver](#dns-resolver)
    - [DHCP Server](#dhcp-server)
    - [VPN Gateway](#vpn-gateway)
    - [Hypervisor](#hypervisor)
 - [Examples: VPS](#examples-vps)
    - [Web Server](#web-server)
    - [LB / Relay](#lb-relay)
    - [Mail Server](#mail-server)
 - [Examples: Misc](#examples-misc)
    - [DAV Server](#dav-server)

## Examples: LAN
What follows are example configurations of possible setups for your local home network.

These examples are written with the following assumptions in mind:
 * You are running a common home-router managed network on `192.168.0.X`
 * Your home-router has the address `192.168.0.1`
 * You have a physical target machine (old hardware, RasPi, NUC etc)

### DNS Resolver
This allows you to evade frighteningly common DNS-level censorship, and set entries for your own network.

A DNS server is usually always paired with DHCP, but you can also run this on its own in a local VM with as little as 64MB RAM.
```
net:
  ifaces:
    - name: eth0
      addr: 192.168.0.123
      netmask: 255.255.255.0
  dns:
    listen:
      - 0.0.0.0
    access:
      - 192.168.0.0/24 allow
```
Any device using this DNS resolver will have ads and malware filtered away without the need of any client software.
If it happens to block something you need, populate the whitelist:
```
    filter:
      whitelist:
        - example.com
        - *.other.net
```
To completely turn it off, set
```
    filter: false
```

Change your client devices' DNS servers to your target's IP, then run `tail -f /var/log/unbound.log` on the target to see your queries flying by.

### DHCP server
This allows you to distribute values like a DNS resolver address (see above) and a default gateway (see below) to the devices in your network.
```
net:
  ifaces:
    - name: eth0
      addr: 192.168.0.123
      netmask: 255.255.255.0
      dhcp:
        - range: 192.168.0.128 192.168.0.254
          domain: mydomain.local
          routers: 192.168.0.1
          leases:
            - name: myclient
              ip: 192.168.0.212
              mac: 00:de:ad:be:ef:00
            - name: otherlease
              ip: 192.168.0.213
              mac: 00:11:22:aa:bb:cc
  dns:
    listen:
      - 0.0.0.0
    access:
      - 192.168.0.0/24 allow
```
You can see it is also running the DNS resolver from further above.
Remember to turn off your home router's DHCP server if you run your own: you don't want to create conflicts.

Run `tail -f /var/log/dhcpd.log` on the target to see the requests.

### VPN Gateway
You can set up a device in your LAN as a VPN gateway, bypassing any kind of regional censorship.

NOTE: this requires a FSA-managed VPS, `myvpshost`, acting as the VPN server.

```
net:
  ifaces:
    - name: eth0
      addr: 192.168.0.123
      netmask: 255.255.255.0
  vpn:
    type: wireguard
    iface: eth0
    addr: 10.0.0.2
    peer:
      name: myvpshost
      addr: vpn.example.com
      keepalive: 32
```

VPN configuration must be applied simultaneously on both client and server. See the [Reference](REFERENCE.md) for the server-side configuration.

Run `ping [peers-internal-addr]` from either client or server to see it working.

### Hypervisor
This allows you to run 1-core virtual machines with OpenBSD, Debian or Alpine.
```
virt:
  bridge: eth0
  vms:
    - name: myvm
      mem: 2G
      size: 10G
      install: alpine
```
`install` will fetch the latest ISO for you and repackage it to boot and install from serial console.

To reuse an already downloaded image, replace `install` with `iso`:
```
      iso: alpine
```

The `install` and `iso` keywords can of course be removed once the target OS is installed.

Run `vmctl show` to see what's up, and `vmctl console [name|id]` to connect to a VM.

Press `~` *then* `Ctrl-d` to disconnect from the console.

## Examples: VPS
What follows are example configurations of possible setups for your Virtual Private Server and Domain.

If you don't have one of those, see the [HowTos](HOWTOS.md).

These examples are written with the following assumptions in mind:
 * Your target has a public IPv4 address with an A-Record pointing to it
 * That A-Record matches the value of `base.name`, eg `myhost.mydomain.net`

### Web Server
This allows you to run a simple PHP-based website. Bigger, more complex stuff like Wordpress will *not* work.

```
web:
  httpd:
    php:
      version: 8.0
      libs:
        - pdo_sqlite
  sites:
    - name: mydomain.net
      alts:
        - www.mydomain.net
      root: /mydomain_webroot
      php: true
      tls: prod
```
For PHP and more advanced configuration see the [Reference](REFERENCE.md).

Run `tail -f /var/www/logs/*.log` to see what's happening.

### LB / Relay
Forward arbitrary things to arbitrary targets.

In this example, traffic to one domain is sent to another host, while traffic to another is sent to the local webserver.
```
web:
  sites:
    - name: mydomain.net
      alts:
        - www.mydomain.net
      tls: prod
    - name: my.special.domain.net
      tls: prod
  relay:
    frontends:
      - name: httpfrontend
        addr: 0.0.0.0
        port: 443
        type: http
        tls: prod
    backends:
      - name: mybackendservers
        port: 80
        front: httpfrontend
        domains:
          - mydomain.net
          - www.mydomain.net
        targets:
          - example.target.com
      - name: alternativebackend
        port: 80
        front: httpfrontend
        domains:
          - my.special.domain.net
        targets:
          - localhost
```

For more advanced forwarding and filtering see the [Reference](REFERENCE.md).

Run `tail -f /var/log/relayd.log` to see it working.

### Mail Server
This enables you to run your own email server, free from big tech AI-assisted dragnet scanning.

In addition to the records output by FSA, the host will require a PTR/rDNS record matching its `base` hostname, set up by your VPS provider or inside their interface.

```mail:
  listen:
    - addr: all
      port: smtp
      tls: true
      filter: spam
    - addr: all
      port: submission
      tls: force
      filter: no
      auth: true
      dkim: true
  domains:
    - example.com
  boxes:
    - addr: myuser@example.com
      pass: crypted value
  virtuals:
    - "alias@example.com    user@example.com"
```
Use `fsa genpass [mypass]` to generate the crypted values required for mailbox passwords.

Client settings: IMAP 143, SMTP 587, both with STARTTLS.
For more configuration options see the [Reference](REFERENCE.md).

Run `tail -f /var/log/maillog` to see the mail server in action.
If set up, spam filter logs are under `/var/log/rspamd/rspamd.log`

## Examples: Misc
Other random things you can do.

### DAV server
This enables you to synchronize calendars and contacts through multiple devices.
```
web:
  httpd:
    php:
      version: 8.0
      libs:
        - pdo_sqlite
  sites:
    - name: dav.domain.net
      root: /webdav
      ssl: prod
      php: true

apps:
  dav:
    site: dav.mydomain.net
    admin:
      - user: adminuser
        pass: adminpass
```
You will still have to manually complete the 3-click GUI setup.

