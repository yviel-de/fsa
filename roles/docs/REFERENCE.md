# Full Reference - yviel's FSA `v0.2.0`

## Table of Contents
 - [Config Reference](#config-reference)
    - [fsa](#fsa)
    - [base](#base)
    - [net](#net)
    - [web](#web)
    - [mail](#mail)
    - [virt](#virt)
    - [apps](#apps)
 - [Table Format](#table-format)
    - [Key](#key)
    - [Type](#type)
    - [Required](#required)
    - [Default](#default)
    - [Summary](#summary)
    - [Role](#role)

## Config Reference
#### fsa
|Key|Type|Required|Default|Summary|Role|
|--|--|--|--|--|--|
|`fsa`|Parent|No|(none)|Parent for various connection options|[fsa_connect](../../roles/fsa_connect)|
|`fsa.user`|String|No|Result of `whoami`|Remote user for SSH|[fsa_connect](../../roles/fsa_connect)|
|`fsa.addr`|String|No|(none)|IP or FQDN of the target host|[fsa_connect](../../roles/fsa_connect)|
|`fsa.port`|Int|No|22|Target host's SSH port|[fsa_connect](../../roles/fsa_connect)|
|`fsa.pass`|Bool|No|`false`|Whether sudo/doas requires a password|[fsa_connect](../../roles/fsa_connect)|
|`fsa.bootstrap`|Bool|No|`false`|Installs python3 on the target, required for FSA|[fsa_connect](../../roles/fsa_connect)|

#### base
|Key|Type|Required|Default|Summary|Role|
|--|--|--|--|--|--|
|`base`|Parent|No|(none)|Activates `base`|[base](../../roles/base)|
|`base.name`|String|Yes|(none)|Hostname of the target|[base](../../roles/base)|
|`base.sound`|Bool|No|`false`|Whether to enable sound|[base](../../roles/base)|
|`base.rootpw`|String|No|(none)|Root user's password hash (use `fsa -g`)|[users](../../roles/users)|
|`base.users`|Dict|No|(none)|Activates `users`|[users](../../roles/users)|
|`base.users.name`|String|Yes|(none)|Username to create|[users](../../roles/users)|
|`base.users.pass`|String|No|(none)|User's password hash (use `fsa -g`)|[users](../../roles/users)|
|`base.users.sudo`|Bool|No|`false`|Whether to give root privileges|[users](../../roles/users)|
|`base.users.nopass`|Bool|No|`false`|If `sudo`, whether to nopass the user|[users](../../roles/users)|
|`base.sshd`|Parent|No|(none)|Activates `sshd`|[sshd](../../roles/sshd)|
|`base.sshd.enabled`|Bool|No|`true`|Whether to enable sshd|[sshd](../../roles/sshd)|
|`base.sshd.tune`|Bool|No|`false`|Whether to set up EC algos|[sshd](../../roles/sshd)|
|`base.sshd.guard`|Bool|No|`false`|Whether to set up sshguard|[sshd](../../roles/sshd)|
|`base.cron`|Dict|No|(none)|Any crontab entries to create|[cron](../../roles/cron)|

#### net
|Key|Type|Required|Default|Summary|Role|
|--|--|--|--|--|--|
|`net`|Parent|No|(none)|Activates `net`|[net](../../roles/net)|
|`net.public`|Bool|No|`false`|Block malicious hosts as determined by spamhaus et al|[fw](../../roles/fw)|
|`net.routing`|Bool|No|`false`|Whether to forward packets|[net](../../roles/net)|
|`net.routes`|List|No|(none)|Any routes to set up|[net](../../roles/net)|
|`net.ifaces`|Dict|Yes|(none)|Network interfaces to configure|[net](../../roles/net)|
|`net.ifaces.name`|String|Yes|(none)|Interface name|[net](../../roles/net)|
|`net.ifaces.addr`|String|No|(none)|IP address if static|[net](../../roles/net)|
|`net.ifaces.netmask`|String|No|(none)|Netmask, if static|[net](../../roles/net)|
|`net.ifaces.vlanid`|Int|No|(none)|VLAN ID, if VLAN interface|[net](../../roles/net)|
|`net.ifaces.parent`|String|No|(none)|If VLAN iface, physical parent interface|[net](../../roles/net)|
|`net.ifaces.dhcp`|Parent|No|(none)|Activates `dhcp`|[dhcp](../../roles/dhcp)|
|`net.ifaces.dhcp.range`|String|Yes|(none)|Available IP range to hand out|[dhcp](../../roles/dhcp)|
|`net.ifaces.dhcp.routers`|String|No|the `iface`'s `addr`|Default gateway to hand out|[dhcp](../../roles/dhcp)|
|`net.ifaces.dhcp.domain`|String|No|`fsa.local`|Domain to hand out|[dhcp](../../roles/dhcp)|
|`net.ifaces.dhcp.dnssrv`|String|No|the `iface`'s `addr`|DNS resolver to hand out|[dhcp](../../roles/dhcp)|
|`net.ifaces.dhcp.lease_time`|Int|No|~24hrs|Lifetime in seconds of leases|[dhcp](../../roles/dhcp)|
|`net.ifaces.dhcp.deny_unknown`|Bool|No|`false`|Whether to deny unknown clients|[dhcp](../../roles/dhcp)|
|`net.ifaces.dhcp.leases`|Dict|No|(none)|Any specific leases to define|[dhcp](../../roles/dhcp)|
|`net.ifaces.dhcp.leases.name`|String|Yes|(none)|Hostname to hand out|[dhcp](../../roles/dhcp)|
|`net.ifaces.dhcp.leases.ip`|String|Yes|(none)|IP to hand out|[dhcp](../../roles/dhcp)|
|`net.ifaces.dhcp.leases.mac`|String|Yes|(none)|Client's MAC address|[dhcp](../../roles/dhcp)|
|`net.ifaces.dhcp.leases.dns`|Bool|No|`true`|Registers clients with local DNS if exists|[dhcp](../../roles/dhcp)|
|`net.dns`|Parent|No|(none)|Activates `dns`|[dns](../../roles/dns)|
|`net.dns.listen`|String|Yes|`127.0.0.1`|Addresses to listen on|[dns](../../roles/dns)|
|`net.dns.access`|List|No|All currently available|Regulate access to the resolver|[dns](../../roles/dns)|
|`net.dns.filter`|Bool/Parent|No|`true`|Whether to adblock bad domains|[dns](../../roles/dns)|
|`net.dns.filter.whitelist`|List|No|(none)|If `filter`, any domains to exempt|[dns](../../roles/dns)|
|`net.dns.localzone`|String|No|(none)|Local zone name|[dns](../../roles/dns)|
|`net.dns.localdata`|List|No|(none)|Any DNS entries to hand out|[dns](../../roles/dns)|
|`net.dns.forward`|Parent|No|(none)|Forward instead of resolving|[dns](../../roles/dns)|
|`net.dns.forward.addr`|List|Yes|Resolver IPs to forward to|[dns](../../roles/dns)|
|`net.dns.forward.tls`|Bool|`true`|Forward with TLS|[dns](../../roles/dns)|
|`net.fw`|Parent|No|(none)|Activates `fw`|[fw](../../roles/fw)|
|`net.fw.rules`|Dict|Yes|(none)|Firewall rules to set up|[fw](../../roles/fw)|
|`net.fw.rules.act`|String|Yes|(none)|Action, `block`, `pass` or `mark`|[fw](../../roles/fw)|
|`net.fw.rules.dir`|String|Yes|(none)|Direction, `in` or `out`|[fw](../../roles/fw)|
|`net.fw.rules.iface`|String|No|(none)|Interface to match|[fw](../../roles/fw)|
|`net.fw.rules.proto`|String|No|(none)|Protocol to match|[fw](../../roles/fw)|
|`net.fw.rules.from`|String|No|(none)|Source IP to match|[fw](../../roles/fw)|
|`net.fw.rules.to`|String|No|(none)|Destination IP to match|[fw](../../roles/fw)|
|`net.fw.rules.port`|Int|No|(none)|Port to match|[fw](../../roles/fw)|
|`net.fw.rules.rdrto`|String|No|(none)|IP address to redirect to|[fw](../../roles/fw)|
|`net.fw.rules.rdrport`|Int|if `rdrto`|(none)|Port to redirect to|[fw](../../roles/fw)|
|`net.fw.rules.natto`|String|No|(none)|Address or interface to NAT to|[fw](../../roles/fw)|
|`net.vpn`|Parent|No|(none)|Activates `vpn`|[vpn](../../roles/vpn)|
|`net.vpn.type`|String|Yes|(none)|Only `wireguard` for now|[vpn](../../roles/vpn)|
|`net.vpn.iface`|String|Yes|(none)|Interface to bind to|[vpn](../../roles/vpn)|
|`net.vpn.addr`|String|Yes|(none)|Machine's IP inside the VPN network|[vpn](../../roles/vpn)|
|`net.vpn.port`|Int|if server|`51820`|Port to listen on|[vpn](../../roles/vpn)|
|`net.vpn.psk`|Bool|No|`false`|Whether to generate and use a Pre-Shared Key|[vpn](../../roles/vpn)|
|`net.vpn.persist`|Bool|No|`false`|Autorestart the connection if it drops|[vpn](../../roles/vpn)|
|`net.vpn.peer`|Parent|if client|(none)|VPN server to use|[vpn](../../roles/vpn)|
|`net.vpn.peer.name`|String|if client|(none)|Inventory name of server host|[vpn](../../roles/vpn)|
|`net.vpn.peer.addr`|String|if client|(none)|IP or Domain name of the server|[vpn](../../roles/vpn)|
|`net.vpn.peer.port`|Int|No|`51820`|VPN server port to connect to|[vpn](../../roles/vpn)|
|`net.vpn.peer.keepalive`|Int|No|(none)|Interval in seconds of keepalive-packets|[vpn](../../roles/vpn)|
|`net.vpn.peers`|Dict|if server|(none)|VPN clients to serve|[vpn](../../roles/vpn)|
|`net.vpn.peers.name`|String|if server|(none)|Inventory name of client|[vpn](../../roles/vpn)|
|`net.vpn.peers.addr`|String|if server|(none)|Client's IP within the VPN net|[vpn](../../roles/vpn)|
|`net.vpn.peers.keepalive`|Int|No|(none)|Interval in seconds of keepalive-packets|[vpn](../../roles/vpn)|



#### web
|Key|Type|Required|Default|Summary|Role|
|--|--|--|--|--|--|
|`web`|Parent|No|(none)|Parent key for httpd, php, relay|(none)|
|`web.httpd`|Bool/Parent|No|`false`|Activates `httpd`|[httpd](../../roles/httpd)|
|`web.httpd.auth`|Dict|No|(none)|Any `htpasswd` entries to set up|[httpd](../../roles/httpd)|
|`web.httpd.auth.name`|String|Yes|(none)|Username to set up|[httpd](../../roles/httpd)|
|`web.httpd.auth.pass`|String|Yes|(none)|Password for the user|[httpd](../../roles/httpd)|
|`web.sites`|Dict|No|(none)|Virtual webhosts to set up|[httpd](../../roles/httpd)|
|`web.sites.name`|String|Yes|(none)|Website's primary address|[httpd](../../roles/httpd)|
|`web.sites.listen`|String|Yes|`all`|Address or interface to listen on|[httpd](../../roles/httpd)|
|`web.sites.root`|String|Yes|(none)|Document-Root, relative to `/var/www`|[httpd](../../roles/httpd)|
|`web.sites.alts`|List|No|(none)|Any alternative domain `name`s|[httpd](../../roles/httpd)|
|`web.sites.tls`|String|No|`false`|Setup LetsEncrypt, `dev` or `prod`|[httpd](../../roles/httpd)|
|`web.sites.index`|String|No|(none)|Default index page to serve|[httpd](../../roles/httpd)|
|`web.sites.php`|Bool|No|`false`|Enable PHP for the vhost|[httpd](../../roles/httpd)|
|`web.httpd.php`|Parent|No|(none)|Activates `php`|[php](../../roles/php)|
|`web.httpd.php.version`|String|Yes|(none)|PHP version to install (`X.Y`)|[php](../../roles/php)|
|`web.httpd.php.libs`|List|No|(none)|Any PHP libraries to install|[php](../../roles/php)|
|`web.relay`|Parent|No|(none)|Activates `relay`|[relay](../../roles/relay)|
|`web.relay.frontends`|Dict|Yes|(none)|Frontends to accept connections on|[relay](../../roles/relay)|
|`web.relay.frontends.name`|String|Yes|(none)|Frontend name|[relay](../../roles/relay)|
|`web.relay.frontends.addr`|String|Yes|(none)|Address to listen on|[relay](../../roles/relay)|
|`web.relay.frontends.port`|Int|Yes|Port to listen on|[relay](../../roles/relay)|
|`web.relay.frontends.type`|String|No|`http`|Relay type, `http`, `tcp` or `dns`|[relay](../../roles/relay)|
|`web.relay.frontends.tls`|String|No|`false`|Sets up LetsEncrypt, `dev` or `prod`|[relay](../../roles/relay)|
|`web.relay.frontends.wsock`|Bool|No|`false`|Enables websockets|[relay](../../roles/relay)|
|`web.relay.backends`|Dict|Yes|(none)|Backends to relay connections to|[relay](../../roles/relay)|
|`web.relay.backends.name`|String|Yes|(none)|Backend name|[relay](../../roles/relay)|
|`web.relay.backends.origin`|String|Yes|(none)|Frontend `name` to take connections from|[relay](../../roles/relay)|
|`web.relay.backends.targets`|List|Yes|(none)|IPs or Hostnames to relay the traffic to|[relay](../../roles/relay)|
|`web.relay.backends.port`|Int|Yes|(none)|Target port to relay to|[relay](../../roles/relay)|
|`web.relay.backends.domains`|List|if TLS is used|(none)|Match traffic for these domains|[relay](../../roles/relay)|
|`web.relay.backends.sources`|List|No|(none)|Match traffic from these IPs or CIDRs|[relay](../../roles/relay)|
|`web.relay.backends.check`|Parent|No|(none)|Whether to healthcheck targets|[relay](../../roles/relay)|
|`web.relay.backends.check.type`|String|Yes|`http`|Protocol to use for the check|[relay](../../roles/relay)|
|`web.relay.backends.check.path`|String|if `type: http`|(none)|Path to check|[relay](../../roles/relay)|
|`web.relay.backends.check.code`|Int|if `type: http`|(none)|HTTP return code to expect|[relay](../../roles/relay)|

#### mail
|Key|Type|Required|Default|Summary|Role|
|--|--|--|--|--|--|
|`mail`|Parent|No|(none)|Activates `mail`|[mail](../../roles/mail)|
|`mail.listen`|Dict|Yes|(none)|Listeners to set up|[mail](../../roles/mail)|
|`mail.listen.addr`|String|Yes|(none)|Addresses to listen on|[mail](../../roles/mail)|
|`mail.listen.port`|Int|Yes|(none)|Port to listen on|[mail](../../roles/mail)|
|`mail.listen.filter`|String|Yes|(none)|Filtering, `none`, `conn`ection-level or full `spam`|[filter](../../roles/filter)|
|`mail.listen.tls`|String|No|`false`|Sets up LetsEncrypt, `dev` or `prod`|[mail](../../roles/mail)|
|`mail.listen.auth`|Bool|No|`false`|Require authentication|[mail](../../roles/mail)|
|`mail.listen.dkim`|Bool|No|`false`|Sign submitted messages with DKIM|[dkim](../../roles/dkim)|
|`mail.listen.whitelist`|Bool|No|`false`|Whether to apply `mail.whitelist`|[mail](../../roles/mail)|
|`mail.domains`|List|Yes|(none)|Domains to accept mail for|[mail](../../roles/mail)|
|`mail.users`|Dict|No|(none)|Sender-only users to set up|[mail](../../roles/mail)|
|`mail.users.name`|String|Yes|(none)|Username to set up|[mail](../../roles/mail)|
|`mail.users.pass`|String|Yes|(none)|Password hash, use `fsa -g`|[mail](../../roles/mail)|
|`mail.boxes`|Dict|No|(none)|Mailboxes to set up|[boxes](../../roles/boxes)|
|`mail.boxes.name`|String|Yes|(none)|Username to set up|[mail](../../roles/mail)|
|`mail.boxes.pass`|String|Yes|(none)|Password hash, use `fsa -g`|[mail](../../roles/mail)|
|`mail.virtuals`|List|No|(none)|Aliases, distribution lists, etc to set up|[mail](../../roles/mail)|
|`mail.whitelist`|List|No|(none)|IP addresses or CIDRs to allow|[mail](../../roles/mail)|

#### virt
|Key|Type|Required|Default|Summary|Role|
|--|--|--|--|--|--|
|`virt`|Parent|No|(none)|Activates `virt`|[virt](../../roles/virt)|
|`virt.bridge`|String|Yes|(none)|Interface to bind VMs to|[virt](../../roles/virt)|
|`virt.vms`|Dict|No|(none)|Activates `vms`|[vms](../../roles/vms)|
|`virt.vms.name`|String|Yes|(none)|Name of the VM|[vms](../../roles/vms)|
|`virt.vms.mem`|String|Yes|(none)|RAM to allocate|[vms](../../roles/vms)|
|`virt.vms.size`|String|Yes|(none)|Disk size|[vms](../../roles/vms)|
|`virt.vms.mac`|String|No|(none)|MAC address|[vms](../../roles/vms)|
|`virt.vms.iso`|String|No|(none)|ISO file or distro name|[isos](../../roles/isos)
|`virt.vms.autostart`|Bool|No|`true`|Whether to autostart on boot|[vms](../../roles/vms)|
|`virt.vms.private`|Bool|No|`false`|If true, puts the VM behind NAT|[vms](../../roles/vms)|
|`virt.vms.template`|Bool|No|`false`|If true, creates a template for [fsa_molecule](../../roles/fsa_molecule)|[vms](../../roles/vms)|
|`virt.vms.install`|Parent|No|(none)|Activates `install`|[install](../../roles/install)|
|`virt.vms.install.os`|String|Yes|(none)|`openbsd` or `alpine`|[install](../../roles/install)|
|`virt.vms.install.time`|String|Yes|(none)|Timezone to set up|[install](../../roles/install)|
|`virt.vms.install.key`|String|Yes|(none)|Path to pubkey to authorize for root|[install](../../roles/install)|
|`virt.vms.install.layout`|String|if `os: alpine`|(none)|Keyboard layout to set up|[install](../../roles/install)|
|`virt.vms.install.rootpw`|String|No|(none)|Root user's PW hash, use `fsa -g`|[install](../../roles/install)|

#### apps
|Key|Type|Required|Default|Summary|Role|
|--|--|--|--|--|--|
|`apps`|Parent|No|(none)|Parent key for apps|(none)|
|`apps.mysql`|Parent|No|(none)|Activates `mysql`|[mysql](../../roles/mysql)|
|`apps.mysql.config`|Dict|No|(none)|Config values for my.cnf|[mysql](../../roles/mysql)|
|`apps.mysql.config.section`|String|Yes|(none)|Section of the ini file|[mysql](../../roles/mysql)|
|`apps.mysql.config.option`|String|Yes|(none)|Config key to set|[mysql](../../roles/mysql)|
|`apps.mysql.config.value`|String|Yes|(none)|Config value to set|[mysql](../../roles/mysql)|
|`apps.mysql.dbs`|Dict|Yes|(none)|Databases to set up|[mysql](../../roles/mysql)|
|`apps.mysql.users`|Dict|No|(none)|Users to set up|[mysql](../../roles/mysql)|
|`apps.mysql.users.name`|String|Yes|(none)|Username to create|[mysql](../../roles/mysql)|
|`apps.mysql.users.pass`|String|Yes|(none)|Password in cleartext|[mysql](../../roles/mysql)|
|`apps.mysql.users.from`|String|No|`127.0.0.1`|User origin|[mysql](../../roles/mysql)|
|`apps.mysql.users.on`|String|No|(none)|Existing `db` to permit the user on|[mysql](../../roles/mysql)|
|`apps.mysql.imports`|Dict|No|(none)|Any SQL imports to perform|[mysql](../../roles/mysql)|
|`apps.mysql.imports.src`|String|Yes|(none)|Path to file, or name of remote DB|[mysql](../../roles/mysql)|
|`apps.mysql.imports.dest`|String|Yes|(none)|Name of existing `db` to import into|[mysql](../../roles/mysql)|
|`apps.mysql.imports.host`|String|if remote `src`|(none)|Address of the remote MySQL host|[mysql](../../roles/mysql)|
|`apps.mysql.imports.user`|String|if remote `src`|(none)|Remote SQL user to use|[mysql](../../roles/mysql)|
|`apps.mysql.imports.pass`|String|if remote `src`|(none)|Password for the remote SQL user, in cleartext|[mysql](../../roles/mysql)|
|`apps.webdav`|Parent|No|(none)|Activates `webdav`|[webdav](../../roles/webdav)|
|`apps.webdav.site`|String|Yes|(none)|Matching `name` in `web.sites`|[webdav](../../roles/webdav)|
|`apps.webdav.admin`|Dict|No|(none)|Admin users to set up|[webdav](../../roles/webdav)|
|`apps.webdav.admin.user`|String|Yes|(none)|Admin username|[webdav](../../roles/webdav)|
|`apps.webdav.admin.pass`|String|Yes|(none)|Password in cleartext for the user|[webdav](../../roles/webdav)|
|`apps.gitea`|Parent|No|(none)|Activates `gitea`|[gitea](../../roles/gitea)|
|`apps.gitea.config`|Dict|No|(none)|Any config keys to set|[gitea](../../roles/gitea)|
|`apps.gitea.config.section`|String|Yes|(none)|Section of the INI file|[gitea](../../roles/gitea)|
|`apps.gitea.config.option`|String|Yes|(none)|Name of the setting|[gitea](../../roles/gitea)|
|`apps.gitea.config.value`|String|Yes|(none)|Value of the setting|[gitea](../../roles/gitea)|

## Table Format
#### Key
The full path to the key, irrespective of parent types.

Example: Both of these constructs are represented here as `foo.bar`.

```
foo:
  bar: true

foo:
  - bar: true
```

#### Type
Either one of String, Int, Bool, List, Dict or Parent.

Examples:

```
# a string is a line of text
string: my beautiful line

# an int is a positive number with no comma
int: 10

# a bool is either true or false
bool: true

# a list has one or more individual keys
list:
  - foo
  - bar

# a dict has one or more individual groups of key-value pairs
dict:
  - foo: true
    bar: 123
  - foo: false
    bar: abc
    def: baz

# a parent is just that
grandparent:
  parent:
    child: true
```

#### Required
If required, the key has to be defined if the parent key is set.

#### Default
Any implicit defaults, ie which apply when the key is unset.

#### Summary
A brief summary of what the key does.

#### Role
Link to the respective [role](../../roles/) for further information and examples.

This is also the keyword to use for `fsa -c`/`fsa -r` to apply the setting (see [fsa](FSA_CMD.md)).
