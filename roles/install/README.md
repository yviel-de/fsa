# `install` - yviel's FSA v0.2.0
This role auto-installs choice OSses on VMs.

## Table of Contents
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

### Dependencies
When called, it activates the following roles:
 - [virt](../virt)
 - [vms](../vms)
 - [httpd](../httpd)
 - [dhcp](../dhcp)
 - [isos](../isos)
 - [cron](../cron)

### Example Usage
The role lives under a `virt.vms` key.

Please note that once the install process has run, you will need to remove those directives for any subsequent runs.

```
virt:
  vms:
      # we define a minimal VM
    - myexamplevm
      mem: 512M
      size: 10G
      install:
        # install openbsd
        os: openbsd
        # set the timezone
        time: Canada/Mountain
        # permit this key for root
        key: ~/.ssh/id_rsa.pub
```

### Reference
|Key|Type|Required|Default|Summary|
|--|--|--|--|--|
|`virt.vms.install`|Parent|No|(none)|Activates `install`|
|`virt.vms.install.os`|String|Yes|(none)|`openbsd` or `alpine` (debian coming)|
|`virt.vms.install.time`|String|Yes|(none)|Timezone to set up|
|`virt.vms.install.key`|String|Yes|(none)|Path to pubkey to authorize for root|
|`virt.vms.install.layout`|String|if `os: alpine`|(none)|Keyboard layout to set up|
|`virt.vms.install.rootpw`|String|No|(none)|Root user's PW hash, use `fsa -g`|

([Full Reference here](docs/REFERENCE.md))

### See Also:
 - [virt](../virt/)
 - [vms](../vms/)
 - [isos](../isos/)
 - [dhcp](../dhcp/)
 - [httpd](../httpd/)
