# `drone` - yviel's FSA v0.3.0

## Table of Contents
 - [Description](#description)
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

### Description
This role installs the [drone](https://docs.drone.io/) CICD system onto a Kubernetes cluster, to be used in conjunction with [Gitea](../gitea/).

### Works Against
- Kubernetes

### Dependencies
This role calls no other roles.

### Example Usage
The role lives under the `apps` key:

```yaml
apps:
  drone:
    url: my.drone.address.com
    admin: username
    runners:
      count: 2
    gitea:
      url: my.gitea.address.com
      # generate the info like here:
      # https://docs.drone.io/server/provider/gitea/
      client: "gitea-client-id"
      secret: "gitea-client-secret"
```

### Reference
|Key|Type|Required|Default|Summary|
|--|--|--|--|--|
|`k8s.drone`|Parent|No|(none)|Install DroneCI|
|`k8s.drone.url`|String|Yes|(none)|URL of the installation|
|`k8s.drone.admin`|String|Yes|(none)|Handle of the admin user|
|`k8s.drone.runners`|Parent|No|(none)|Runner-specific settings|
|`k8s.drone.runners.count`|Int|No|2|Amount of runners to create|
|`k8s.drone.runners.insecure_registry`|String|No|(none)|Address:port or CIDR of non-TLS registry|
|`k8s.drone.gitea`|Parent|Yes|(none)|Gitea-specific settings|
|`k8s.drone.gitea.url`|String|Yes|(none)|Gitea server URL|
|`k8s.drone.gitea.client`|String|Yes|(none)|OAuth client ID on Gitea|
|`k8s.drone.gitea.secret`|String|Yes|(none)|OAuth secret for Gitea|

([Full Reference here](../../docs/REFERENCE.md))

### See Also
 - [relay](../relay)
