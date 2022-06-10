# `base` - yviel's FSA v0.2.0
This role handles base configuration of the machine, hostname, MOTD etc.

## Table of Contents
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

### Dependencies
This role calls no other roles.

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
|`base.name`|String|Yes|(none)|Target's full FQDN|
|`base.sound`|Bool|No|`false`|Whether to enable sound|

([Full Reference here](docs/REFERENCE.md))

### See Also
 - [cron](../cron)
 - [users](../users)
 - [sshd](../sshd)
