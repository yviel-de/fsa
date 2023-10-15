# `k8s` - yviel's FSA v0.3.0

## Table of Contents
 - [Description](#description)
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

### Description
This role configures Kubernetes things.

### Works Against
- Kubernetes

### Dependencies
This role calls no other roles.

### Example Usage

The role lives under its own key:

```yaml
k8s:
  # things to install from helm
  helm:
    repos:
      - name: my-repo
        url: https://my-repo-url
      - name: my-other-repo
        url: https://my-other-repo-url
    install:
      - name: my-release
        namespace: my-namespace
        repo: my-repo
        setvalues:
          mykey: myvalue
```

### Reference
|Key|Type|Required|Default|Summary|
|--|--|--|--|--|
|`k8s.helm`|Parent|No|(none)|Install helm charts|
|`k8s.helm.repos`|Dict|No|(none)|Repos to set up|
|`k8s.helm.repos.name`|String|Yes|(none)|Name to save the repo as|
|`k8s.helm.repos.url`|String|Yes|(none)|URL of the repo|
|`k8s.install.name`|String|Yes|(none)|Name of the release to install|
|`k8s.install.repo`|String|Yes|(none)|Repo name to install it from|
|`k8s.install.namespace`|String|Yes|`default`|Namespace to create and install in|
|`k8s.install.setvalues`|Parent|No|(none)|Any values to pass through to the chart|

([Full Reference here](../../docs/REFERENCE.md))

### See Also
 - [relay](../relay)
