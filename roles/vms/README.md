# `vms` - yviel's FSA v0.3.0

## Table of Contents
 - [Description](#description)
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
    - [Simple Example](#simple-example)
    - [Automagic ISO](#automagic-iso)
    - [Autoinstall](#autoinstall)
 - [Reference](#reference)
 - [See Also](#see-also)

### Description
This role sets up 1-core VMs on the underlying hypervisor.

### Works Against
- OpenBSD
- Alpine

### Dependencies
When called, it activates the following roles:
 - [virt](../virt)

### Example Usage
#### Simple Example
```yaml
virt:
  # interface to bind the VMs on
  bridge: eth0
  vms:
    - name: myvm
      # RAM
      mem: 512M
      # disk
      size: 10G
```

#### Automagic ISO
```yaml
virt:
  bridge: eth0
  vms:
    - name: localisofile
      mem: 512M
      size: 10G
      # this searches for the iso file at that path
      iso: /tmp/myinstallmedia.iso
    - name: automagiciso
      mem: 512M
      size: 10G
      # this fetches and repackages an alpine iso
      iso: alpine
```

#### Autoinstall
```yaml
virt:
  bridge: eth0
  vms:
    - name: autoinstall
      mem: 512M
      size: 10G
      install:
        # install alpine linux
        os: alpine
        # timezone
        time: Canada/Mountain
        # keyboard layout
        layout: us
        # pubkey to authorize for root
        key: ~/.ssh/id_rsa.pub
```

### Reference
|Key|Type|Required|Default|Summary|
|--|--|--|--|--|
|`virt.vms`|Dict|No|(none)|Activates the `vms` role|
|`virt.vms.name`|String|Yes|(none)|Name of the VM|
|`virt.vms.mem`|String|Yes|(none)|RAM to allocate|
|`virt.vms.size`|String|Yes|(none)|Disk size|
|`virt.vms.mac`|String|No|(none)|MAC address|
|`virt.vms.iso`|String|No|(none)|Absolute path to ISO file or one of `openbsd`, `alpine`, `debian`|
|`virt.vms.reboot`|Bool|No|`false`|Stops and starts the VM|
|`virt.vms.autostart`|Bool|No|`true`|Whether to autostart on boot|
|`virt.vms.private`|Bool|No|`false`|If true, puts the VM behind NAT|
|`virt.vms.install`|Parent|No|(none)|Auto-installs an OS on the guest|

([Full Reference here](../../docs/REFERENCE.md))

### See Also
 - [virt](../virt)
 - [isos](../isos)
 - [install](../install)
