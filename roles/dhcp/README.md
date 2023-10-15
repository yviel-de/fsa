# `dhcp` - yviel's FSA v0.3.0

## Table of Contents
 - [Description](#description)
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
    - [Simple Example](#simple-example)
    - [Restrictive Example](#restrictive-example)
 - [Reference](#reference)
 - [See Also](#see-also)

### Description
This role sets up a DHCP server for automatically configuring IP addresses for network devices.

*Note*: If you want to run your own DHCP, you should turn off your router's as they will otherwise conflict.

### Works Against
- OpenBSD

### Dependencies
When called, it activates the following roles:
 - [net](../net)
 - [syslog](../syslog)

### Example Usage
The role lives under a `net.ifaces` key.

Any interface *serving* DHCP must be configured statically.

#### Simple Example
This assumes your machine is 10.0.0.1 and acting as a router/gateway.
```yaml
net:
  ifaces:
    - name: eth0
      # static ip configuration required for dhcp server
      addr: 10.0.0.1
      netmask: 255.255.255.0
      # enable the dhcp server for this interface
      dhcp:
          # range in which to hand out leases
        - range: 10.0.0.2 10.0.0.127
          # default gateway to give out to the clients
          routers: 10.0.0.1
          # domain name to give to the clients
          domain: example.local
```

#### Restrictive Example
This hands out leases only to defined clients.
```yaml
net:
  ifaces:
    - name: eth0
      addr: 10.0.0.1
      netmask: 255.255.255.0
      dhcp:
        - range: 10.0.0.2 10.0.0.127
          routers: 10.0.0.1
          domain: example.local
          # we deny unknown clients
          deny_unknown: true
          # and explicitly define our own
          leases:
            - name: myclient
              ip: 10.0.0.42
              mac: 00:de:ad:be:ef:00
```

### Reference
|Key|Type|Required|Default|Summary|
|--|--|--|--|--|--|
|`net.ifaces.dhcp.range`|String|Yes|(none)|IP range to hand out leases for|
|`net.ifaces.dhcp.routers`|String|No|the `iface`'s `addr`|Default gateway to give to clients|
|`net.ifaces.dhcp.domain`|String|No|`fsa.local`|Domain to hand out to clients|
|`net.ifaces.dhcp.dnssrv`|String|No|the `iface`'s `addr`|DNS resolver to hand out to clients|
|`net.ifaces.dhcp.lease_time`|Int|No|about 24hrs|Lifetime of leases, in seconds|
|`net.ifaces.dhcp.deny_unknown`|Bool|No|`false`|Whether to deny unknown clients|
|`net.ifaces.dhcp.leases`|Dict|No|(none)|Any specific leases to define|
|`net.ifaces.dhcp.leases.name`|String|Yes|(none)|Hostname of the specified client|
|`net.ifaces.dhcp.leases.ip`|String|Yes|(none)|IP address to assign to it|
|`net.ifaces.dhcp.leases.mac`|String|Yes|(none)|MAC i.E. hardware address of the client|
|`net.ifaces.dhcp.leases.dns`|Bool|No|`true`|If a local DNS server exists, publish the clients on it|

([Full Reference here](../../docs/REFERENCE.md))

### See Also
 - [dns](../dns)
 - [net](../net)
