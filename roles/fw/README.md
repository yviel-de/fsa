# `fw` - yviel's FSA v0.2.0
This role sets up a firewall using pf.

## Table of Contents
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
    - [Minimal Example](#minimal-example)
    - [Block Malicious Actors](#block-malicious-actors)
    - [NAT Example](#nat-example)
 - [Reference](#reference)
 - [See Also](#see-also)

### Dependencies
When called, it activates the following roles:
 - [net](../net)
 - [cron](../cron)

### Example Usage
#### Minimal Example
The role lives under the `net` key:

```yaml
net:
  fw:
    rules:
        # this rule allows connections from 10.0.0.1
      - act: pass
        dir: in
        from: 10.0.0.1
```

#### Block Malicious Actors
```
net:
  # this blocks malicious actors as identified by spamhaus et al
  public: true
```

#### NAT Example
```
net:
  fw:
    rules:
      # NAT all traffic from 192.168.0.1/24 network out to eth0 iface & addr
      act: pass
      dir: out
      iface: eth0
      from: 192.168.0.1/24
      natto: eth0
```

### Reference
|Key|Type|Required|Default|Summary|
|--|--|--|--|--|
|`net.public`|Bool|No|`false`|Block malicious hosts as determined by spamhaus et al|
|`net.fw.rules`|Dict|Yes|(none)|Firewall rules to set up|
|`net.fw.rules.act`|String|Yes|(none)|Action, `block`, `pass` or `mark`|
|`net.fw.rules.dir`|String|Yes|(none)|Direction, `in` or `out`|
|`net.fw.rules.iface`|String|No|(none)|Interface to match|
|`net.fw.rules.proto`|String|No|(none)|Protocol to match|
|`net.fw.rules.from`|String|No|(none)|Source IP to match|
|`net.fw.rules.to`|String|No|(none)|Destination IP to match|
|`net.fw.rules.port`|Int|No|(none)|Port to match|
|`net.fw.rules.rdrto`|String|No|(none)|IP address to redirect to|
|`net.fw.rules.rdrport`|Int|if `rdrto`|(none)|Port to redirect to|
|`net.fw.rules.natto`|String|No|(none)|Address or interface to NAT to|

([Full Reference here](docs/REFERENCE.md))

### See Also
 - [net](../net/)
