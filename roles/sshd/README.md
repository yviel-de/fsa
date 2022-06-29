# `sshd` - yviel's FSA v0.2.0
This role sets up sshd, with optional sshguard and EC algos.

## Table of Contents
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

### Dependencies
When called, it activates the following roles:
 - [net](../net)
 - [syslog](../syslog)

### Example Usage
The role lives under the `base` key:

```yaml
base:
  sshd:
    # enable sshguard
    guard: true
    # enable EC algos
    tune: true
```

### Reference
|Key|Type|Required|Default|Summary|
|--|--|--|--|--|
|`base.sshd`|Parent|No|(none)|Activates `sshd`|
|`base.sshd.enabled`|Bool|No|`true`|Whether to enable sshd|
|`base.sshd.tune`|Bool|No|`false`|Whether to set up EC algos|
|`base.sshd.guard`|Bool|No|`false`|Whether to set up sshguard|

([Full Reference here](docs/REFERENCE.md))

### See Also
 - [base](../base)
 - [users](../users)
 - [net](../net)
