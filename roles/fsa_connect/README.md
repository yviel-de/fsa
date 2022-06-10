# `fsa_connect` - yviel's FSA v0.2.0
This is a utility role designed to work in tandem with [fsa](docs/FSA_CMD.md) to set various connection parameters for target hosts.

## Table of Contents
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

### Dependencies
This role calls no other roles.

### Example Usage
These settings are used by `fsa` to dynamically build playbooks.
```yaml
fsa:
  addr: 10.0.0.1
  os: openbsd
  user: root
  bootstrap: true
```

### Reference
|Key|Type|Required|Default|Summary|Role|
|--|--|--|--|--|--|
|`fsa`|Parent|No|(none)|Parent for various connection options|
|`fsa.user`|String|No|Result of `whoami`|Remote user for SSH|
|`fsa.addr`|String|No|(none)|IP or FQDN of the target host|
|`fsa.port`|Int|No|22|Target host's SSH port|
|`fsa.pass`|Bool|No|`false`|Whether sudo/doas requires a password|
|`fsa.bootstrap`|Bool|No|`false`|Installs python3 on the target, required for FSA|

([Full Reference here](docs/REFERENCE.md))

### See Also
 - [fsa Command Docs](../utils/docs/FSA_CMD.md)
