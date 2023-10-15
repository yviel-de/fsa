# `fsa_connect` - yviel's FSA v0.3.0

## Table of Contents
 - [Description](#description)
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Kubernetes](#kubernetes)
 - [Development](#development)
 - [Reference](#reference)
 - [See Also](#see-also)

### Description
This role works in tandem with [fsa](../../docs/FSA_CMD.md) to set various connection parameters to target hosts.

### Works Against
- FSA-Internal

### Dependencies
This role calls no other roles.

### Example Usage
These settings are used by `fsa` to dynamically build playbooks.
```yaml
fsa:
  # name or ip if the config file's name doesn't resolve
  addr: 10.0.0.1
  # use doas instead of sudo, if required
  os: openbsd
  # log in as root (if nonroot, see 'os' above)
  user: root
  # use ~/.ssh/privatekeyfile for ssh
  keyfile: ~/.ssh/privatekeyfile
  # install python3 for FSA to work
  bootstrap: true
```

### Kubernetes
Managing k8s clusters is possible aswell.
```yaml
# this uses the "default" context of the default kubeconfig
fsa:
  k8s: true
```

```yaml
fsa:
  k8s:
    # specify a different ~/.kube/config file
    conffile: /path/to/my/conf
    # specify a kube context
    context: "my-kube-context-name"
```

### Development
`fsa_connect` can be included both as a role by tasks and as a playbook by other playbooks:
```yaml
### included in task:
- include_role:
    name: fsa_connect
  vars:
    target: "{{ some_other_host }}"

### included as playbook:
- import_playbook: roles/fsa_connect/connect.yaml
```

### Reference
|Key|Type|Required|Default|Summary|
|--|--|--|--|--|--|
|`fsa`|Parent|No|(none)|Parent for various connection options|
|`fsa.user`|String|No|Result of `whoami`|Remote user for SSH|
|`fsa.addr`|String|No|(none)|IP or FQDN of the target host|
|`fsa.port`|Int|No|22|Target host's SSH port|
|`fsa.keyfile`|String|No|`~/.ssh/id_rsa`|SSH Private Key for Ansible to use|
|`fsa.pass`|Bool|No|`false`|Whether sudo/doas requires a password|
|`fsa.bootstrap`|Bool|No|`false`|Installs python3 on the target, required for FSA|
|`fsa.k8s`|Parent|No|(none)|Enables Kubernetes management|
|`fsa.k8s.conffile`|String|No|`~/.kube/config`|Nonstandard path to config file|
|`fsa.k8s.context`|String|No|(none)|Specific kubectl context to use|

([Full Reference here](../../docs/REFERENCE.md))

### See Also
 - [fsa Command Docs](../../docs/FSA_CMD.md)
