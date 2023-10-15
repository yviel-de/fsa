# Full Reference - yviel's FSA v0.3.0

## Table of Contents
 - [Config Reference](#config-reference)
    - [fsa](#fsa)
    - [base](#base)
    - [net](#net)
    - [web](#web)
    - [mail](#mail)
    - [virt](#virt)
    - [apps](#apps)
    - [k8s](#k8s)
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
|`fsa`|Parent|No|(none)|Parent for various connection options|[fsa_connect](../roles/fsa_connect)|
|`fsa.user`|String|No|Result of `whoami`|Remote user for SSH|[fsa_connect](../roles/fsa_connect)|
|`fsa.addr`|String|No|(none)|IP or FQDN of the target host|[fsa_connect](../roles/fsa_connect)|
|`fsa.port`|Int|No|22|Target host's SSH port|[fsa_connect](../roles/fsa_connect)|
|`fsa.keyfile`|String|No|`~/.ssh/id_rsa`|SSH Private Key for Ansible to use|
|`fsa.pass`|Bool|No|`false`|Whether sudo/doas requires a password|[fsa_connect](../roles/fsa_connect)|
|`fsa.bootstrap`|Bool|No|`false`|Installs python3 on the target, required for FSA|[fsa_connect](../roles/fsa_connect)|
|`fsa.k8s`|Parent|No|(none)|Enables Kubernetes management|[fsa_connect](../roles/fsa_connect)|
|`fsa.k8s.conffile`|String|No|`~/.kube/config`|Nonstandard path to config file|[fsa_connect](../roles/fsa_connect)|
|`fsa.k8s.context`|String|No|(none)|Specific kubectl context to use|[fsa_connect](../roles/fsa_connect)|

#### base
|Key|Type|Required|Default|Summary|Role|
|--|--|--|--|--|--|
|`base`|Parent|No|(none)|Activates `base`|[base](../roles/base)|
|`base.name`|String|Yes|(none)|Target's full FQDN i.E. `myhost.mydomain.local`|[base](../roles/base)|
|`base.sound`|Bool|No|`false`|Whether to enable sound|[base](../roles/base)|
|`base.rootpw`|String|No|(none)|Root user's password hash (use `fsa -g`)|[users](../roles/users)|
|`base.users`|Dict|No|(none)|Activates `users`|[users](../roles/users)|
|`base.users.name`|String|Yes|(none)|Username to create|[users](../roles/users)|
|`base.users.pass`|String|No|(none)|User's password hash (use `fsa -g`)|[users](../roles/users)|
|`base.users.sudo`|Bool|No|`false`|Whether to give root privileges|[users](../roles/users)|
|`base.users.nopass`|Bool|No|`false`|If `sudo`, whether to nopass the user|[users](../roles/users)|
|`base.sshd`|Parent|No|(none)|Activates `sshd`|[sshd](../roles/sshd)|
|`base.sshd.enabled`|Bool|No|`true`|Whether to disable sshd|[sshd](../roles/sshd)|
|`base.sshd.tune`|Bool|No|`false`|Whether to set up EC algos|[sshd](../roles/sshd)|
|`base.sshd.guard`|Bool|No|`false`|Whether to set up sshguard|[sshd](../roles/sshd)|
|`base.cron`|Parent|No|(none)|Activates `cron`|[cron](../roles/cron)|
|`base.cron.entries`|Dict|No|(none)|Generic cron entries to create|[cron](../roles/cron)|
|`base.cron.entries.schedule`|String|Yes|(none)|`daily`, `weekly`, or `monthly`|[cron](../roles/cron)|
|`base.cron.entries.user`|String|No|`root`|User to execute command as|[cron](../roles/cron)|
|`base.cron.entries.command`|String|Yes|(none|Command to execute|[cron](../roles/cron)|
|`base.cron.raw`|List|No|(none)|Any raw crontab lines to create|[cron](../roles/cron)|
|`base.autoupdate`|Bool|No|`false`|Sets up a daily system update cron|[cron](../roles/cron)|

#### net
|Key|Type|Required|Default|Summary|Role|
|--|--|--|--|--|--|
|`net`|Parent|No|(none)|Activates `net`|[net](../roles/net)|
|`net.public`|Bool|No|`false`|Block malicious hosts as determined by spamhaus et al|[fw](../roles/fw)|
|`net.routing`|Bool|No|`false`|Whether to forward packets|[net](../roles/net)|
|`net.routes`|List|No|(none)|Any routes to set up|[net](../roles/net)|
|`net.ifaces`|Dict|Yes|(none)|Network interfaces to configure|[net](../roles/net)|
|`net.ifaces.name`|String|Yes|(none)|Interface name, use `fsa -f` to find|[net](../roles/net)|
|`net.ifaces.addr`|String|No|(none)|IP address if static|[net](../roles/net)|
|`net.ifaces.netmask`|String|No|(none)|Netmask, if static|[net](../roles/net)|
|`net.ifaces.vlanid`|Int|No|(none)|VLAN ID, if VLAN interface|[net](../roles/net)|
|`net.ifaces.parent`|String|No|(none)|If VLAN iface, physical parent interface|[net](../roles/net)|
|`net.ifaces.dhcp`|Parent|No|(none)|Activates `dhcp`|[dhcp](../roles/dhcp)|
|`net.ifaces.dhcp.range`|String|Yes|(none)|IP range to hand out leases for|[dhcp](../roles/dhcp)|
|`net.ifaces.dhcp.routers`|String|No|the `iface`'s `addr`|Default gateway to give to clients|[dhcp](../roles/dhcp)|
|`net.ifaces.dhcp.domain`|String|No|`fsa.local`|Domain to hand out to clients|[dhcp](../roles/dhcp)|
|`net.ifaces.dhcp.dnssrv`|String|No|the `iface`'s `addr`|DNS resolver to hand out to clients|[dhcp](../roles/dhcp)|
|`net.ifaces.dhcp.lease_time`|Int|No|about 24hrs|Lifetime of leases, in seconds|[dhcp](../roles/dhcp)|
|`net.ifaces.dhcp.deny_unknown`|Bool|No|`false`|Whether to deny unknown clients|[dhcp](../roles/dhcp)|
|`net.ifaces.dhcp.leases`|Dict|No|(none)|Any specific leases to define|[dhcp](../roles/dhcp)|
|`net.ifaces.dhcp.leases.name`|String|Yes|(none)|Hostname of the specified client|[dhcp](../roles/dhcp)|
|`net.ifaces.dhcp.leases.ip`|String|Yes|(none)|IP address to assign to it|[dhcp](../roles/dhcp)|
|`net.ifaces.dhcp.leases.mac`|String|Yes|(none)|MAC i.E. hardware address of the client|[dhcp](../roles/dhcp)|
|`net.ifaces.dhcp.leases.dns`|Bool|No|`true`|If a local DNS server exists, publish the clients on it|[dhcp](../roles/dhcp)|
|`net.dns`|Parent|No|(none)|Activates `dns`|[dns](../roles/dns)|
|`net.dns.listen`|String|Yes|`127.0.0.1`|Addresses to listen on|[dns](../roles/dns)|
|`net.dns.access`|List|No|Networks the machine is connected to|Limit access to these IPs/CIDRs|[dns](../roles/dns)|
|`net.dns.filter`|Bool/Parent|No|`true`|Whether to adblock bad domains|[dns](../roles/dns)|
|`net.dns.filter.whitelist`|List|No|(none)|Domains to exempt from adblocking|[dns](../roles/dns)|
|`net.dns.localzone`|String|No|(none)|Name of the local zone|[dns](../roles/dns)|
|`net.dns.localdata`|List|No|(none)|Any DNS entries to hand out|[dns](../roles/dns)|
|`net.dns.forward`|Parent|No|(none)|Forward queries instead of resolving them|[dns](../roles/dns)|
|`net.dns.forward.addr`|List|Yes|(none)|Resolver IPs to forward to|[dns](../roles/dns)|
|`net.dns.forward.tls`|Bool|Yes|`true`|Forward with TLS|[dns](../roles/dns)|
|`net.fw`|Parent|No|(none)|Activates `fw`|[fw](../roles/fw)|
|`net.fw.rules`|Dict|Yes|(none)|Firewall rules to set up|[fw](../roles/fw)|
|`net.fw.rules.act`|String|Yes|(none)|Action, `block` or `pass`|[fw](../roles/fw)|
|`net.fw.rules.dir`|String|Yes|(none)|Direction, `in` or `out`|[fw](../roles/fw)|
|`net.fw.rules.iface`|String|No|(none)|Interface to match|[fw](../roles/fw)|
|`net.fw.rules.proto`|String|No|(none)|Protocol to match|[fw](../roles/fw)|
|`net.fw.rules.from`|String|No|(none)|Source IP to match|[fw](../roles/fw)|
|`net.fw.rules.to`|String|No|(none)|Destination IP to match|[fw](../roles/fw)|
|`net.fw.rules.port`|Int|No|(none)|Port to match|[fw](../roles/fw)|
|`net.fw.rules.rdrto`|String|No|(none)|IP address to redirect to|[fw](../roles/fw)|
|`net.fw.rules.rdrport`|Int|if `rdrto`|(none)|Port to redirect to|[fw](../roles/fw)|
|`net.fw.rules.natto`|String|No|(none)|Address or interface to NAT to|[fw](../roles/fw)|
|`net.vpn`|Parent|No|(none)|Activates `vpn`|[vpn](../roles/vpn)|
|`net.vpn.type`|String|Yes|(none)|Only `wireguard` for now|[vpn](../roles/vpn)|
|`net.vpn.iface`|String|Yes|(none)|Interface to bind to|[vpn](../roles/vpn)|
|`net.vpn.myaddr`|String|Yes|(none)|Machine's IP inside the VPN network|[vpn](../roles/vpn)|
|`net.vpn.natout`|Bool|No|`false`|Whether to NAT out VPN Clients|[vpn](../roles/vpn)|
|`net.vpn.peers`|Dict|Yes|(none)|VPN peers to connect to|[vpn](../roles/vpn)|
|`net.vpn.peers.name`|String|Yes|(none)|Inventory name of peer, or generic identifier string|[vpn](../roles/vpn)|
|`net.vpn.peers.addr`|String|Yes|(none)|If `listen: true`, peer's VPN IP. If `listen:false`, peer's public address|[vpn](../roles/vpn)|
|`net.vpn.peers.listen`|Bool|No|`false`|If true, listens to incoming connections (instead of connecting out)|[vpn](../roles/vpn)|
|`net.vpn.peers.pubkey`|String|No|(none)|Public key of peer. If undefined, will attempt to autoretrieve from inventory `name`|[vpn](../roles/vpn)|
|`net.vpn.peers.psk`|String|No|(none)|Preshared Key. Can be the key contents, but can also be `remote` or `local`. Between FSA hosts this will be autoconfigured.|
|`net.vpn.peers.keepalive`|Int|No|(none)|Interval in seconds of keepalive-packets to send|[vpn](../roles/vpn)|


#### web
|Key|Type|Required|Default|Summary|Role|
|--|--|--|--|--|--|
|`web`|Parent|No|(none)|Parent key for httpd, php, relay|(none)|
|`web.httpd`|Bool/Parent|No|`false`|Activates `httpd`|[httpd](../roles/httpd)|
|`web.httpd.auth`|Dict|No|(none)|Any `htpasswd` entries to set up|[httpd](../roles/httpd)|
|`web.httpd.auth.name`|String|Yes|(none)|Username to set up|[httpd](../roles/httpd)|
|`web.httpd.auth.pass`|String|Yes|(none)|Password for the user|[httpd](../roles/httpd)|
|`web.sites`|Dict|No|(none)|Virtual webhosts to set up|[httpd](../roles/httpd)|
|`web.sites.name`|String|Yes|(none)|Website's primary address|[httpd](../roles/httpd)|
|`web.sites.listen`|String|Yes|`all`|Address or interface to listen on|[httpd](../roles/httpd)|
|`web.sites.port`|Int|No|default ones|Alternative port to listen on|[httpd](../roles/httpd)|
|`web.sites.root`|String|Yes|(none)|Document-Root, relative to `/var/www`|[httpd](../roles/httpd)|
|`web.sites.alts`|List|No|(none)|Any alternative domain `name`s|[httpd](../roles/httpd)|
|`web.sites.tls`|String|No|`false`|Setup LetsEncrypt, `dev` or `prod`|[httpd](../roles/httpd)|
|`web.sites.index`|String|No|(none)|Default index page to serve|[httpd](../roles/httpd)|
|`web.sites.php`|Bool|No|`false`|Enable PHP for the vhost|[httpd](../roles/httpd)|
|`web.php`|Parent|No|(none)|Activates `php`|[php](../roles/php)|
|`web.php.version`|String|Yes|(none)|PHP version to install (`X.Y`)|[php](../roles/php)|
|`web.php.libs`|List|No|(none)|Any PHP libraries to install|[php](../roles/php)|
|`web.relay`|Parent|No|(none)|Activates `relay`|[relay](../roles/relay)|
|`web.relay.frontends`|Dict|Yes|(none)|Frontends to accept connections on|[relay](../roles/relay)|
|`web.relay.frontends.name`|String|Yes|(none)|Frontend name|[relay](../roles/relay)|
|`web.relay.frontends.addr`|String|Yes|(none)|Address to listen on|[relay](../roles/relay)|
|`web.relay.frontends.port`|Int|Yes|(none)|Port to listen on|[relay](../roles/relay)|
|`web.relay.frontends.type`|String|No|`http`|Relay type, `http`, `tcp` or `dns`|[relay](../roles/relay)|
|`web.relay.frontends.tls`|String|No|`false`|Sets up LetsEncrypt, `dev` or `prod`|[relay](../roles/relay)|
|`web.relay.frontends.wsock`|Bool|No|`false`|Enables websockets|[relay](../roles/relay)|
|`web.relay.backends`|Dict|Yes|(none)|Backends to relay connections to|[relay](../roles/relay)|
|`web.relay.backends.name`|String|Yes|(none)|Backend name|[relay](../roles/relay)|
|`web.relay.backends.type`|String|Yes|(none)|Either `http`, `tcp` or `dns`|[relay](../roles/relay)
|`web.relay.backends.origin`|String|Yes|(none)|Frontend `name` to take connections from|[relay](../roles/relay)|
|`web.relay.backends.targets`|List|Yes|(none)|IPs or Hostnames to relay the traffic to|[relay](../roles/relay)|
|`web.relay.backends.port`|Int|Yes|(none)|Target port to relay to|[relay](../roles/relay)|
|`web.relay.backends.domains`|List|if TLS is used|(none)|Match traffic for these domains|[relay](../roles/relay)|
|`web.relay.backends.sources`|List|No|All|Match traffic from these IPs or CIDRs|[relay](../roles/relay)|
|`web.relay.backends.check`|Parent|No|(none)|Whether to healthcheck targets|[relay](../roles/relay)|
|`web.relay.backends.check.type`|String|Yes|(none)|Protocol for the check: `http`, `https`, `tcp`, `icmp`, `tls`|[relay](../roles/relay)|
|`web.relay.backends.check.path`|String|if `check.type: http` or `https`|(none)|Path to check|[relay](../roles/relay)|
|`web.relay.backends.check.code`|Int|if `check.type: http` or `https`|(none)|HTTP return code to expect|[relay](../roles/relay)|

#### mail
|Key|Type|Required|Default|Summary|Role|
|--|--|--|--|--|--|
|`mail`|Parent|No|(none)|Activates `mail`|[mail](../roles/mail)|
|`mail.setup`|Bool|No|`false`|Whether to display the DKIM pubkeys and other DNS information|[dkim](../roles/dkim)|
|`mail.listen`|Dict|Yes|(none)|Listeners to set up|[mail](../roles/mail)|
|`mail.listen.addr`|String|Yes|(none)|Addresses to listen on|[mail](../roles/mail)|
|`mail.listen.port`|Int|Yes|(none)|Port to listen on|[mail](../roles/mail)|
|`mail.listen.filter`|String|Yes|(none)|Filtering level: `none`, `conn`ection or full `spam`|[filter](../roles/filter)|
|`mail.listen.tls`|String|No|`false`|Sets up LetsEncrypt, `dev` or `prod`|[mail](../roles/mail)|
|`mail.listen.auth`|Bool|No|`false`|Require authentication|[mail](../roles/mail)|
|`mail.listen.dkim`|Bool|No|`false`|Sign submitted messages with DKIM|[dkim](../roles/dkim)|
|`mail.listen.whitelist`|Bool|No|`false`|Apply `mail.whitelist` to this listener|[mail](../roles/mail)|
|`mail.domains`|List|Yes|(none)|Domains to accept mail for|[mail](../roles/mail)|
|`mail.users`|Dict|No|(none)|Sender-only users to set up|[mail](../roles/mail)|
|`mail.users.name`|String|Yes|(none)|Username to set up|[mail](../roles/mail)|
|`mail.users.pass`|String|Yes|(none)|Password hash, use `fsa -g`|[mail](../roles/mail)|
|`mail.boxes`|Dict|No|(none)|Mailboxes to set up|[boxes](../roles/boxes)|
|`mail.boxes.addr`|String|Yes|(none)|Email address to set up|[mail](../roles/mail)|
|`mail.boxes.pass`|String|Yes|(none)|Password hash, use `fsa -g` to generate|[mail](../roles/mail)|
|`mail.virtuals`|List|No|(none)|Aliases, distribution lists, etc to set up|[mail](../roles/mail)|
|`mail.whitelist`|List|No|(none)|IP addresses or CIDRs to forward mail for|[mail](../roles/mail)|
|`mail.relay`|String|No|(none)|Hostname of the server all incoming mail will be relayed to|

#### virt
|Key|Type|Required|Default|Summary|Role|
|--|--|--|--|--|--|
|`virt`|Parent|No|(none)|Activates `virt`|[virt](../roles/virt)|
|`virt.bridge`|String|Yes|(none)|Interface to bind VMs to, as defined in `net.ifaces.name`|[virt](../roles/virt)|
|`virt.vms`|Dict|No|(none)|Activates the `vms` role|[vms](../roles/vms)|
|`virt.vms.name`|String|Yes|(none)|Name of the VM|[vms](../roles/vms)|
|`virt.vms.mem`|String|Yes|(none)|RAM to allocate|[vms](../roles/vms)|
|`virt.vms.size`|String|Yes|(none)|Disk size|[vms](../roles/vms)|
|`virt.vms.mac`|String|No|(none)|MAC address|[vms](../roles/vms)|
|`virt.vms.iso`|String|No|(none)|Absolute path to ISO file or one of `openbsd`, `alpine`, `debian`|[isos](../roles/isos)|
|`virt.vms.reboot`|Bool|No|`false`|Stops and starts the VM|[vms](../roles/vms)
|`virt.vms.autostart`|Bool|No|`true`|Whether to autostart on boot|[vms](../roles/vms)|
|`virt.vms.private`|Bool|No|`false`|If true, puts the VM behind NAT|[vms](../roles/vms)|
|`virt.vms.install`|Parent|No|(none)|Auto-installs an OS on the guest|[install](../roles/install)|
|`virt.vms.install.os`|String|Yes|(none)|`openbsd` or `alpine`, installs latest version|[install](../roles/install)|
|`virt.vms.install.time`|String|Yes|(none)|Timezone to set up|[install](../roles/install)|
|`virt.vms.install.key`|String|Yes|(none)|Path to pubkey to authorize for root|[install](../roles/install)|
|`virt.vms.install.layout`|String|if `os: alpine`|(none)|Keyboard layout to set up|[install](../roles/install)|
|`virt.vms.install.rootpw`|String|No|(none)|Root user's PW hash, use `fsa -g`|[install](../roles/install)|
|`virt.vms.install.template`|Bool|No|`false`|Prepares VM for exporting to Vagrantbox|[install](../roles/install)|

#### apps
|Key|Type|Required|Default|Summary|Role|
|--|--|--|--|--|--|
|`apps`|Parent|No|(none)|Parent key for apps|(none)|
|`apps.mysql`|Parent|No|(none)|Activates `mysql`|[mysql](../roles/mysql)|
|`apps.mysql.config`|Dict|No|(none)|Config values for my.cnf|[mysql](../roles/mysql)|
|`apps.mysql.config.section`|String|Yes|(none)|Section of the ini file|[mysql](../roles/mysql)|
|`apps.mysql.config.option`|String|Yes|(none)|Config key to set|[mysql](../roles/mysql)|
|`apps.mysql.config.value`|String|Yes|(none)|Config value to set|[mysql](../roles/mysql)|
|`apps.mysql.dbs`|List|Yes|(none)|Databases to set up|[mysql](../roles/mysql)|
|`apps.mysql.users`|Dict|No|(none)|Users to set up|[mysql](../roles/mysql)|
|`apps.mysql.users.name`|String|Yes|(none)|Username to create|[mysql](../roles/mysql)|
|`apps.mysql.users.pass`|String|Yes|(none)|Password in cleartext|[mysql](../roles/mysql)|
|`apps.mysql.users.from`|String|No|`localhost`|User origin|[mysql](../roles/mysql)|
|`apps.mysql.users.ondb`|String|Yes|(none)|Existing `db` to permit the user on|[mysql](../roles/mysql)|
|`apps.mysql.imports`|Dict|No|(none)|Any SQL imports to perform|[mysql](../roles/mysql)|
|`apps.mysql.imports.src`|String|Yes|(none)|Path to local file, or name of remote DB|[mysql](../roles/mysql)|
|`apps.mysql.imports.dest`|String|Yes|(none)|Name of existing `db` to import into|[mysql](../roles/mysql)|
|`apps.mysql.imports.host`|String|if remote `src`|(none)|Address of the remote MySQL host|[mysql](../roles/mysql)|
|`apps.mysql.imports.user`|String|if remote `src`|(none)|Remote SQL user to use|[mysql](../roles/mysql)|
|`apps.mysql.imports.pass`|String|if remote `src`|(none)|Password for the remote SQL user, in cleartext|[mysql](../roles/mysql)|
|`apps.webdav`|Parent|No|(none)|Activates `webdav`|[webdav](../roles/webdav)|
|`apps.webdav.host`|String|No|127.0.0.1|Address to listen on|[webdav](../roles/webdav)|
|`apps.webdav.port`|Int|No|5232|Port to listen on|[webdav](../roles/webdav)|
|`apps.webdav.users`|Dict|Yes|(none)|WebDAV users to create|[webdav](../roles/webdav)|
|`apps.webdav.users.name`|String|Yes|(none)|Username|[webdav](../roles/webdav)|
|`apps.webdav.users.pass`|String|Yes|(none)|Password (cleartext)|[webdav](../roles/webdav)|
|`apps.webdav.tls`|String|No|(none)|Signs with letsencrypt-staging (dev) or letsencrypt (prod)|[webdav](../roles/webdav)|
|`apps.webdav.domain`|String|if `tls` is defined|(none)|Domain name, required if you setup tls|[webdav](../roles/webdav)|
|`apps.webdav.fs_folder`|String|No|/var/db/radicale/collections|Folder for storing local collections|[webdav](../roles/webdav)|
|`apps.gitea`|Parent|No|(none)|Install Gitea|[gitea](../roles/gitea)|
|`apps.gitea.name`|String|No|My Beautiful Gitea|Name of the installation|[gitea](../roles/gitea)|
|`apps.gitea.url`|String|Yes|(none)|Full URL including protocol of the install|[gitea](../roles/gitea)|
|`apps.gitea.install`|String|No|`false`|Unlocks the install screen|[gitea](../roles/gitea)|
|`apps.gitea.config`|Dict|No|(none)|Any config keys to set|[gitea](../roles/gitea)|
|`apps.gitea.config.section`|String|Yes|(none)|Section of the INI file|[gitea](../roles/gitea)|
|`apps.gitea.config.option`|String|Yes|(none)|Name of the setting|[gitea](../roles/gitea)|
|`apps.gitea.config.value`|String|Yes|(none)|Value of the setting|[gitea](../roles/gitea)|
|`apps.mpd`|Parent|No|(none)|Sets up MPD|[mpd](../roles/mpd)|
|`apps.mpd.listen`|String|No|`any`|Listen address|[mpd](../roles/mpd)|
|`apps.mpd.port`|String|No|`6600`|Listen port|[mpd](../roles/mpd)|
|`apps.mpd.storage`|String|No|`/var/lib/mpd/music`|Path to store music|[mpd](../roles/mpd)|
|`apps.mpd.webradio`|Bool|No|`false`|Setup chosen webradios from somafm and others|[mpd](../roles/mpd)|
|`apps.mpd.sources`|Dict|No|(none)|Playlist files to download|[mpd](../roles/mpd)|
|`apps.mpd.sources.name`|Bool|Yes|(none)|Name to save it under|[mpd](../roles/mpd)|
|`apps.mpd.sources.source`|Bool|Yes|(none)|Web location of `.pls` file|[mpd](../roles/mpd)|
|`apps.k3s`|Parent|No|(none)|Activates `k3s`|
|`apps.k3s.type`|String|Yes|(none)|`server` to setup a k3s server, or `agent` to setup k3s agent|
|`apps.k3s.name`|String|No|(none)|Sets the name of the server/agent node|
|`apps.k3s.token`|String|No|(none)|Sets the token|
|`apps.k3s.retrieve_config`|Bool|No|false|Saves remote server's k3s config locally to ~/.kube/config|
|`apps.k3s.server`|String|If `type: agent`|(none)|k3s server's endpoint (must specify https)|
|`apps.k3s.upgrade`|Bool|No|false|Upgrade existing k3s installation|
|`apps.k3s.join`|String|No|(none)|Hostname of server for retrieving token through SSH|
|`apps.k3s.db`|Dict|No|(none)|Embedded (etcd) or External DB (postgres, mysql/mariadb) for k3s server to use|
|`apps.k3s.db.type`|String|Yes|(none)|`etcd` or `mysql` or `postgres`. Please specify `mysql` if you are using mariadb|
|`apps.k3s.db.user`|String|If `db.type`: `postgres` or `mysql`|(none)|database username|
|`apps.k3s.db.pass`|String|If `db.type`: `postgres` or `mysql`|(none)|database password|
|`apps.k3s.db.database`|String|If `db.type`: `postgres` or `mysql`|(none)|name of the database|
|`apps.k3s.db.host`|String|If `db.type`: `postgres` or `mysql`|(none)|database hostname|
|`apps.k3s.db.port`|Int|If `db.type`: `postgres` or `mysql`|(none)|database port|
|`apps.k3s.db.endpoints`|List|if `db.type: etcd`|(none)|etcd database endpoints|

#### k8s
|Key|Type|Required|Default|Summary|Role|
|--|--|--|--|--|--|
|`k8s.helm`|Parent|No|(none)|Install helm charts|[k8s](../roles/k8s)|
|`k8s.helm.repos`|Dict|No|(none)|Repos to set up|[k8s](../roles/k8s)|
|`k8s.helm.repos.name`|String|Yes|(none)|Name to save the repo as|[k8s](../roles/k8s)|
|`k8s.helm.repos.url`|String|Yes|(none)|URL of the repo|[k8s](../roles/k8s)|
|`k8s.install.name`|String|Yes|(none)|Name of the release to install|[k8s](../roles/k8s)|
|`k8s.install.repo`|String|Yes|(none)|Repo name to install it from|[k8s](../roles/k8s)|
|`k8s.install.namespace`|String|Yes|`default`|Namespace to create and install in|[k8s](../roles/k8s)|
|`k8s.install.setvalues`|Parent|No|(none)|Any values to pass through to the chart|[k8s](../roles/k8s)|
|`k8s.drone`|Parent|No|(none)|Install DroneCI|[drone](../roles/drone)|
|`k8s.drone.url`|String|Yes|(none)|URL of the installation|[drone](../roles/drone)|
|`k8s.drone.admin`|String|Yes|(none)|Handle of the admin user|[drone](../roles/drone)|
|`k8s.drone.runners`|Parent|No|(none)|Runner-specific settings|[drone](../roles/drone)|
|`k8s.drone.runners.count`|Int|No|2|Amount of runners to create|[drone](../roles/drone)|
|`k8s.drone.runners.insecure_registry`|String|No|(none)|Address:port or CIDR of non-TLS registry|[drone](../roles/drone)|
|`k8s.drone.gitea`|Parent|Yes|(none)|Gitea-specific settings|[drone](../roles/drone)|
|`k8s.drone.gitea.url`|String|Yes|(none)|Gitea server URL|[drone](../roles/drone)|
|`k8s.drone.gitea.client`|String|Yes|(none)|OAuth client ID on Gitea|[drone](../roles/drone)|
|`k8s.drone.gitea.secret`|String|Yes|(none)|OAuth secret for Gitea|[drone](../roles/drone)|


## Table Description
#### Key
The full path to the key, irrespective of parent types.

Example: Both of these constructs are represented here as `foo.bar`.

```yaml
foo:
  bar: true

foo:
  - bar: true
```

#### Type
Either one of String, Int, Bool, List, Dict or Parent.

Examples:

```yaml
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
Link to the respective role for further information and examples.

This is also the keyword to use for `fsa -c`/`fsa -r` to apply the setting (see [fsa](FSA_CMD.md)).
