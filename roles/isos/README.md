# `isos` - yviel's FSA v0.2.0
This role downloads install media for choice OSses and configures them to output to serial console.

Once an ISO is built, it is re-used for 3 months before it is re-built.

## Table of Contents
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

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
|`virt.vms.iso`|String|No|(none)|Absolute path to iso file, or `openbsd`/`alpine`/`debian`.|

([Full Reference here](docs/REFERENCE.md))

### See Also
 - [virt](../virt/)
 - [vms](../vms/)
 - [install](../install/)
