# `vpn` - yviel's FSA v0.2.0
This role sets up a wireguard client or server.

Please note that currently both server and client need to be managed by FSA, and the configuration for both *must be applied simultaneously*.

## Table of Contents
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
    - [Client Example](#client-example)
    - [Server Example](#server-example)
 - [Reference](#reference)
 - [See Also](#see-also)

### Dependencies
When called, it activates the following roles:
 - [net](../net)
 - [fw](../fw)
 - [cron](../cron)

### Example Usage
The role lives under the `net` key.

#### Client Example
```yaml
net:
  vpn:
    type: wireguard
    # iface through which to run the VPN
    iface: eth0
    # vpn-internal address
    addr: 172.16.0.2
    peer:
      # must be an existing fsa host
      name: myvpnserver
      # vpn-internal server address
      addr: 172.16.0.1
```

#### Server Example
```yaml
net:
  vpn:
    type: wireguard
    # interface to listen on
    iface: eth0
    # vpn-internal address
    addr: 172.16.0.1
    peers:
        # existing fsa host
      - name: myvpnclient
        # vpn-internal client ip
        addr: 172.16.0.2
```

### Reference
|Key|Type|Required|Default|Summary|
|--|--|--|--|--|
|`net.vpn`|Parent|No|(none)|Activates `vpn`|
|`net.vpn.type`|String|Yes|(none)|Only `wireguard` for now|
|`net.vpn.iface`|String|Yes|(none)|Interface to bind to|
|`net.vpn.addr`|String|Yes|(none)|Machine's IP inside the VPN network|
|`net.vpn.port`|Int|if server|`51820`|Port to listen on|
|`net.vpn.psk`|Bool|No|`false`|Whether to generate and use a Pre-Shared Key|
|`net.vpn.persist`|Bool|No|`false`|Autorestart the connection if it drops|
|`net.vpn.peer`|Parent|if client|(none)|VPN server to use|
|`net.vpn.peer.name`|String|if client|(none)|Inventory name of server host|
|`net.vpn.peer.addr`|String|if client|(none)|IP or Domain name of the server|
|`net.vpn.peer.port`|Int|No|`51820`|VPN server port to connect to|
|`net.vpn.peer.keepalive`|Int|No|(none)|Interval in seconds of keepalive-packets|
|`net.vpn.peers`|Dict|if server|(none)|VPN clients to serve|
|`net.vpn.peers.name`|String|if server|(none)|Inventory name of client|
|`net.vpn.peers.addr`|String|if server|(none)|Client's IP within the VPN net|
|`net.vpn.peers.keepalive`|Int|No|(none)|Interval in seconds of keepalive-packets|

([Full Reference here](docs/REFERENCE.md))

### See Also
 - [net](../net)
