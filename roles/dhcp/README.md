# `dhcp` - yviel's FSA v0.2.0
This role sets up a dhcpd server.

## Table of Contents
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
    - [Simple Example](#simple-example)
    - [Restrictive Example](#restrictive-example)
 - [Reference](#reference)
 - [See Also](#see-also)

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
|Key|Type|Required|Example Value|Default Value|Action|
|--|--|--|--|--|--|
|`net.ifaces.dhcp.range`|String|Yes|`10.0.0.2 10.0.0.127`|(none)|IP range of the leases to hand out|
|`net.ifaces.dhcp.routers`|String|Yes|`10.0.0.1`|(none)|Default gateway to give to clients|
|`net.ifaces.dhcp.domain`|String|No|`example.local`|`fsa.local`|Domain to hand out to clients|
|`net.ifaces.dhcp.dnssrv`|String|No|`10.0.0.1`|(none)|DNS server addr to give to clients|
|`net.ifaces.dhcp.lease_time`|Integer|No|`21600`|about 24hrs|Lifetime of the leases handed out|
|`net.ifaces.dhcp.deny_unknown`|String|No|`true`|`false`|Whether to deny unknown clients|
|`net.ifaces.dhcp.leases`|Null|No|(none)|(none)|Any DHCP leases to define|
|`net.ifaces.dhcp.leases.name`|String|Yes|`myclienthost`|(none)|Hostname of the client|
|`net.ifaces.dhcp.leases.ip`|String|Yes|`10.0.0.42`|(none)|IP address to assign|
|`net.ifaces.dhcp.leases.mac`|String|Yes|`00:de:ad:be:ef:00`|(none)|MAC address of the client|
|`net.ifaces.dhcp.leases.dns`|String|No|`false`|`true`|If a DNS server is setup, register with it|

([Full Reference here](docs/REFERENCE.md))

### See Also
 - [dns](../dns)
 - [net](../net)
