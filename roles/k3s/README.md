# `k3s` - yviel's FSA v0.3.0

## Table of Contents
 - [Description](#description)
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

### Description
This role sets up [k3s](https://k3s.io) Lightweight Container Orchestration System, with wireguard-native as flannel backend and traefik disabled

### Dependencies
The role has no dependencies

### Example Usage
The role lives under the `apps` key

The role can be used to setup a k3s server
```yaml
apps:
  k3s:
    type: server
    token: "myfancytoken"
    # upgrade: true 
    retrieve_config: true
    db:
      type: mysql
      name: k3s_server
      user: mysqlusr
      pass: mysqlpasswd
      host: fsaisgud.com
      port: 3306
      database: k3sdb
    # you could also specify etcd endpoints
    # db:
    # type: etcd
    # endpoints:
    #   - http://etcd-host-1:2379
    #   - http://etcd-host-2:2379
```
Or a k3s agent node
```yaml
apps:
  k3s:
    type: agent
    name: k3s_agent_01
    server: "https://fsaisgud.org:6443"
    token: "myfancytoken"
```

### Reference
|Key|Type|Required|Default|Summary|
|--|--|--|--|--|
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
