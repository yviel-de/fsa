# `dns` - yviel's FSA v0.3.0

## Table of Contents
 - [Description](#description)
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
    - [Minimal Example](#minimal-example)
    - [Limit Access, Forward Queries](#limit-access-forward-queries)
 - [Reference](#reference)
 - [See Also](#see-also)

### Description
This role sets up a DNS server, which translates names like `example.com` to IP addresses to connect to.

In addition to the usual features it can also perform adblocking.

### Works Against
- OpenBSD

### Dependencies
When called, it activates the following roles:
 - [net](../net)
 - [syslog](../syslog)
 - [cron](../cron)

### Example Usage
#### Minimal Example
The role lives under the `net` key:

```yaml
net:
  dns:
    # listen on all interfaces
    listen:
      - 0.0.0.0
    # custom data to hand out to the clients
    localdata:
      - myhost.example.local. IN A 10.0.0.42
      - example.local. IN TXT "my lovely string"
```

#### Limit Access, Forward Queries
```yaml
net:
  dns:
    # listen on all
    listen:
      - 0.0.0.0
    # give access to the entire net except .42
    access:
      - 10.0.0.0/24 allow
      - 10.0.0.42 deny
    # forward queries instead of resolving them itself
    forward:
      addr:
        - 9.9.9.9
        - 149.112.112.112
```

### Reference
|Key|Type|Required|Default Value|Action|
|--|--|--|--|--|--|
|`net.dns`|Parent|No|(none)|Activates `dns`|
|`net.dns.listen`|String|Yes|`127.0.0.1`|Addresses to listen on|
|`net.dns.access`|List|No|Networks the machine is connected to|Limit access to these IPs/CIDRs|
|`net.dns.filter`|Bool/Parent|No|`true`|Whether to adblock bad domains|
|`net.dns.filter.whitelist`|List|No|(none)|Domains to exempt from adblocking|
|`net.dns.localzone`|String|No|(none)|Name of the local zone|
|`net.dns.localdata`|List|No|(none)|Any DNS entries to hand out|
|`net.dns.forward`|Parent|No|(none)|Forward queries instead of resolving them|
|`net.dns.forward.tls`|Bool|Yes|`true`|Forward with TLS|
|`net.dns.forward.addr`|List|Yes|(none)|Resolver IPs to forward to|

([Full Reference here](../../docs/REFERENCE.md))

### See Also
 - [net](../net/)
 - [dhcp](../dhcp/)
