# `users` - yviel's FSA v0.2.0
This role sets up users and their sudo/doas permissions.

## Table of Contents
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

### Dependencies
This role calls no other roles.

### Example Usage
The role lives under the `base` key:

```yaml
base:
  users:
      # name of the user to create
    - name: myuser
      # whether to set up root privs
      sudo: true
      # if sudo, whether to set it up with nopass
      nopass: true
```

### Reference
|Key|Type|Required|Default|Summary|
|--|--|--|--|--|
|`base.users`|Dict|No|(none)|Activates `users`|
|`base.users.name`|String|Yes|(none)|Username to create|
|`base.users.pass`|String|No|(none)|User's password hash (use `fsa -g`)|
|`base.users.sudo`|Bool|No|`false`|Whether to give root privileges|
|`base.users.nopass`|Bool|No|`false`|If `sudo`, whether to nopass the user|

([Full Reference here](docs/REFERENCE.md))

### See Also
 - [base](../base)
 - [sshd](../sshd)
