# `vpn` - yviel's FSA v0.3.0

## Table of Contents
 - [Description](#description)
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
    - [Client Example](#client-example)
    - [Server Example](#server-example)
 - [Reference](#reference)
 - [See Also](#see-also)

### Description
This role sets up a wireguard client and server.

Note that at the moment configuration of both client and server must happen simultaneously.

### Works Against
- OpenBSD

### Dependencies
When called, it activates the following roles:
 - [net](../net)
 - [fw](../fw)
 - [cron](../cron)

### Example Usage
The role lives under the `net` key.

#### Example
```yaml
net:
  routing: true
  vpn:
    type: wireguard
    # interface to use for connections
    iface: eth0
    # addr inside the vpn
    myaddr: 172.16.0.1
    # NAT outgoing connections
    natout: true
    # my vpn peers
    peers:
      - name: mypeer
        addr: 172.16.0.2
        pubkey: "my-longass-pubkey-string"
        # listen for incoming connections
        listen: true

# a client would have these options set instead
net:
  vpn:
    type: wireguard
    iface: eth0
    myaddr: 172.16.0.2
    peers:
      - name: myserver
        addr: vpn.example.com
        pubkey: "my-longass-pubkey-string"
        keepalive: 25
```

### Reference
|Key|Type|Required|Default|Summary|
|--|--|--|--|--|
|`net.vpn`|Parent|No|(none)|Activates `vpn`|
|`net.vpn.type`|String|Yes|(none)|Only `wireguard` for now|
|`net.vpn.iface`|String|Yes|(none)|Interface to bind to|
|`net.vpn.myaddr`|String|Yes|(none)|Machine's IP inside the VPN network|
|`net.vpn.natout`|Bool|No|`false`|Whether to NAT out VPN Clients|
|`net.vpn.peers`|Dict|Yes|(none)|VPN peers to connect to|
|`net.vpn.peers.name`|String|Yes|(none)|Inventory name of peer, or generic identifier string|
|`net.vpn.peers.addr`|String|Yes|(none)|If `listen: true`, peer's VPN IP. If `listen:false`, peer's public address|
|`net.vpn.peers.listen`|Bool|No|`false`|If true, listens to incoming connections (instead of connecting out)|
|`net.vpn.peers.pubkey`|String|No|(none)|Public key of peer. If undefined, will attempt to autoretrieve from inventory `name`|
|`net.vpn.peers.psk`|String|No|(none)|Preshared Key. Can be the key contents, but can also be `remote` or `local`. Between FSA hosts this will be autoconfigured.|
|`net.vpn.peers.keepalive`|Int|No|(none)|Interval in seconds of keepalive-packets to send|

([Full Reference here](../../docs/REFERENCE.md))

### See Also
 - [net](../net)
