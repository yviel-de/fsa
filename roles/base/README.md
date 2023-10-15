# `base` - yviel's FSA v0.3.0

## Table of Contents
 - [Description](#description)
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

### Description
This role configures base system settings like the system name.

### Dependencies
This role calls no other roles.

### Works Against
- OpenBSD
- Alpine

### Example Usage
```yaml
base:
  # set the hostname
  name: host.example.local
  # enable sound
  sound: true
```

### Reference
|Key|Type|Required|Default|Summary|
|--|--|--|--|--|--|
|`base`|Parent|No|(none)|Activates `base`|
|`base.name`|String|Yes|(none)|Target's full FQDN i.E. `myhost.mydomain.local`|
|`base.sound`|Bool|No|`false`|Whether to enable sound|

([Full Reference here](../../docs/REFERENCE.md))

### See Also
 - [cron](../cron)
 - [users](../users)
 - [sshd](../sshd)
