# `net` - yviel's FSA v0.3.0

## Table of Contents
 - [Description](#description)
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
    - [Minimal Example](#minimal-example)
    - [Static Configuration](#static-configuration)
    - [VLAN Interface](#vlan-interface)
 - [Reference](#reference)
 - [See Also](#see-also)

### Description
This role sets up basic networking, iE configures interfaces and routes.

### Works Against
- OpenBSD
- Alpine

### Dependencies
When called, it activates the following roles:
 - [cron](../net)

### Example Usage
#### Minimal Example

With nothing defined, the interface is configured via DHCP.

You can use `fsa -f myhost` to find your interface names.
```yaml
net:
  ifaces:
    # just the interface name for DHCP
    - name: eth0
```

#### Static Configuration with gateway
```yaml
net:
  routes:
    - default 10.0.0.123
  ifaces:
    - name: eth0
      addr: 10.0.0.1
      netmask: 255.255.255.0
```

#### VLAN Interface
```yaml
net:
  ifaces:
    - name: eth0
    - name: vlan10
      vlanid: 10
      parent: eth0
```

### Reference
|Key|Type|Required|Default|Summary|
|--|--|--|--|--|
|`net`|Parent|No|(none)|Activates `net`|
|`net.routing`|Bool|No|`false`|Whether to forward packets|
|`net.routes`|List|No|(none)|Any routes to set up|
|`net.ifaces`|Dict|Yes|(none)|Network interfaces to configure|
|`net.ifaces.name`|String|Yes|(none)|Interface name, use `fsa -f` to find|
|`net.ifaces.addr`|String|No|(none)|IP address if static|
|`net.ifaces.netmask`|String|No|(none)|Netmask, if static|
|`net.ifaces.vlanid`|Int|No|(none)|VLAN ID, if VLAN interface|
|`net.ifaces.parent`|String|No|(none)|If VLAN iface, physical parent interface|

([Full Reference here](../../docs/REFERENCE.md))

### See Also
 - [fw](../fw)
 - [dhcp](../dhcp)
 - [dns](../dns)
 - [vpn](../vpn)
