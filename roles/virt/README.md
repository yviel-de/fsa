# `virt` - yviel's FSA v0.2.0
This role sets up VMD as a hypervisor.

It creates two internal NATted networks, 172.19.24.0/24 for VMs marked `private`, and 100.92.0.1/24 for VMs used by [install](../install/) and [fsa_molecule](../fsa_molecule/).

## Table of Contents
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

### Dependencies
When called, it activates the following roles:
 - [net](../net)
 - [dhcp](../dhcp)
 - [dns](../dns)
 - [fw](../fw)

### Example Usage

See [vms](../vms) for more sophisticated examples.

```yaml
virt:
  # the interface to which VMs will be bound
  bridge: eth0
  vms:
    - name: myvm
      # RAM
      mem: 512M
      # disk
      size: 10G
```

### Reference
|Key|Type|Required|Default|Summary|
|--|--|--|--|--|
|`virt`|Parent|No|(none)|Activates `virt`|
|`virt.bridge`|String|Yes|(none)|Interface to bind VMs to (must be defined in `net.ifaces`)|[virt]|
|`virt.vms`|Dict|No|(none)|Activates [vms](../vms)|

([Full Reference here](docs/REFERENCE.md))

### See Also
 - [vms](../vms)
 - [isos](../isos)
 - [install](../install)
 - [fsa_molecule](../fsa_molecule)
