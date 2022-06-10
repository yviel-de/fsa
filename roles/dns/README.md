# `dns` - yviel's FSA v0.2.0
This role sets up a DNS server using unbound.

## Table of Contents
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
    - [Minimal Example](#minimal-example)
    - [Limit Access, Forward Queries](#limit-access-forward-queries)
 - [Reference](#reference)
 - [See Also](#see-also)

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
|Key|Type|Required|Example Value|Default Value|Action|
|--|--|--|--|--|--|
|`net.dns.listen`|String|Yes|`0.0.0.0`|(none)|Interfaces/addresses to listen on|
|`net.dns.access`|List|No|`- 10.0.0.0/24 allow`<br/>`- 10.0.0.72/30 deny`|(none)|Limit access to the resolver|
|`net.dns.filter`|Bool/Null|No|`false`|`true`|Whether to adblock|
|`net.dns.filter.whitelist`|List|No|`- analytics.google.com`<br/>`- *.doubleclick.net`|(none)|Domains to exempt from adblocking|
|`net.dns.localzone`|String|No|`mynet.local`|(none)|Your local zone|
|`net.dns.localdata`|List|No|`- myhost.example.com. IN A 10.0.0.1`<br/>`- txt.thing.local. IN TXT "my beautiful string"`|(none)|Arbitrary DNS entries to hand out|
|`net.dns.forward`|Null|No|(none)|(none)|Whether to forward queries to another resolver|
|`net.dns.forward.tls`|Bool|Yes|`false`|`true`|Forward with TLS|
|`net.dns.forward.addr`|List|Yes|`- 9.9.9.9`<br/>`- 149.112.112.112`|(none)|Resolver addresses to forward to|

([Full Reference here](docs/REFERENCE.md))

### See Also
 - [net](../net/)
 - [dhcp](../dhcp/)
