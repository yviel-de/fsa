# `relay` - yviel's FSA v0.3.0

## Table of Contents
 - [Description](#description)
 - [Dependencies](#dependencies)
    - [Minimal Example](#minimal-example)
    - [Header- & IP-based Routing](#header--and-ip-based-routing)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

### Description
This role sets up a L3/L7 loadbalancer and reverse proxy allowing for dynamic routing based on things like Source IP and Host-Header.

### Works Against
- OpenBSD

### Dependencies
When called, it activates the following roles:
 - [tls](../tls)
 - [syslog](../syslog)

### Example Usage
#### Minimal Example
The role lives under the `web` key:

```yaml
web:
  # activate the relay
  relay:
    # frontend to accept connections on
    frontends:
      # basic http frontend
      - name: myfrontend
        addr: 0.0.0.0
        type: http
        port: 80
    # backends to forward those connections to
    backends:
      - name: mybackend
        origin: myfrontend
        # balance between those two targets
        targets:
          - 10.0.0.2
          - 10.0.0.3
        port: 80
```

#### Header- and IP-based routing
```yaml
web:
  relay:
    frontends:
      # basic http frontend
      - name: myfrontend
        addr: 0.0.0.0
        type: http
        port: 80
    backends:
      # this one only takes connections from `sources` *and* for host `domains`
      - name: ipbackend
        origin: myfrontend
        # balance between these two targets
        targets:
          - webserver.example.com
          - 10.0.0.2
        port: 8080
        # requests for this domain go here
        domains:
          - foo.example.com
        # requests from these sources go here
        sources:
          - 10.0.1.0/24
          - 10.0.2.1
      # and this one takes any connection for host `domains`, but routes them elsewhere
      - name: allbackend
        origin: myfrontend
        targets:
          - localhost
        port: 8080
        # requests for these domains go here
        domains:
          - foo.example.com
          - bar.example.com
```

### Reference
|Key|eype|Required|Default|Summary|
|--|--|--|--|--|
|`web.relay`|Parent|No|(none)|Activates `relay`|
|`web.relay.frontends`|Dict|Yes|(none)|Frontends to accept connections on|
|`web.relay.frontends.name`|String|Yes|(none)|Frontend name|
|`web.relay.frontends.addr`|String|Yes|(none)|Address to listen on|
|`web.relay.frontends.port`|Int|Yes|(none)|Port to listen on|
|`web.relay.frontends.type`|String|No|`http`|Relay type, `http`, `tcp` or `dns`|
|`web.relay.frontends.tls`|String|No|`false`|Sets up LetsEncrypt, `dev` or `prod`|
|`web.relay.frontends.wsock`|Bool|No|`false`|Enables websockets|
|`web.relay.backends`|Dict|Yes|(none)|Backends to relay connections to|
|`web.relay.backends.name`|String|Yes|(none)|Backend name|
|`web.relay.backends.type`|String|Yes|(none)|Either `http`, `tcp` or `dns`|
|`web.relay.backends.origin`|String|Yes|(none)|Frontend `name` to take connections from|
|`web.relay.backends.targets`|List|Yes|(none)|IPs or Hostnames to relay the traffic to|
|`web.relay.backends.port`|Int|Yes|(none)|Target port to relay to|
|`web.relay.backends.domains`|List|if TLS is used|(none)|Match traffic for these domains|
|`web.relay.backends.sources`|List|No|All|Match traffic from these IPs or CIDRs|
|`web.relay.backends.check`|Parent|No|(none)|Whether to healthcheck targets|
|`web.relay.backends.check.type`|String|Yes|(none)|Protocol for the check: `http`, `https`, `tcp`, `icmp`, `tls`|
|`web.relay.backends.check.path`|String|if `check.type: http` or `https`|(none)|Path to check|
|`web.relay.backends.check.code`|Int|if `check.type: http` or `https`|(none)|HTTP return code to expect|

([Full Reference here](../../docs/REFERENCE.md))

### See Also
 - [net](../net)
 - [httpd](../httpd)
