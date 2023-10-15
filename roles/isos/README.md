# `isos` - yviel's FSA v0.3.0

## Table of Contents
 - [Description](#description)
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

### Description
This role downloads install media for select OSses and reconfigures it to output to serial console.

### Works Against
- OpenBSD
- Alpine

### Dependencies
This role calls no other roles.

### Example Usage
The role lives under a `virt.vms` key:

```yaml
virt:
  vms:
    - myexamplevm
      mem: 512M
      size: 10G
      # download, prepare and boot the latest debian iso
      iso: debian
```

### Reference
|Key|Type|Required|Default|Summary|
|--|--|--|--|--|
|`virt.vms.iso`|String|No|(none)|Absolute path to ISO file or one of `openbsd`, `alpine`, `debian`|

([Full Reference here](../../docs/REFERENCE.md))

### See Also
 - [virt](../virt/)
 - [vms](../vms/)
 - [install](../install/)
