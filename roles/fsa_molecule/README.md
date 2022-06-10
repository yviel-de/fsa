# fsa_molecule - yviel's FSA v0.2.0
### Description
This is a delegated [molecule](https://molecule.readthedocs.io/) driver for creating and destroying VMs on an OpenBSD fsa [virt](../virt) host.

It is not meant to be ran manually, and is hard-ignored by `fsa`.

It creates VMs with 256MB RAM from the basis of disk templates created using [vms](../vms/).

If the scenario name is `default`, it will only run the role once during converge. This is to test one of FSA's design aspects.

###### Why?

Because of [this](https://github.com/vagrant-libvirt/vagrant-libvirt/issues/1371).

## Table of Contents
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

### Dependencies
The role assumes a pre-existing FSA-configured OpenBSD `virt` host.

It is otherwise built to be "plugged-in", with the following settings in your scenario's `molecule.yml`:

```yaml
provisioner:
  # delegated
  name: ansible
  # set the roles path so all are available
  env:
    ANSIBLE_ROLES_PATH: "../"
  # use the fsa_molecule playbooks
  playbooks:
    create: ../../../fsa_molecule/create.yaml
    converge: ../../../fsa_molecule/converge.yaml
    destroy: ../../../fsa_molecule/destroy.yaml
```

### Example Usage
The instances are defined with these keywords in the `molecule.yml`:
```
platforms:
    # name of the instance, must be unique in the scenario
  - name: myexamplename
    # hypervisor host to create them on
    host: myexistinghost
    # existing template to use
    type: myexistingtemplate
  - name: mysecondinstance
    host: myexistinghost
    type: myothertemplate
    bootstrap: true
    updates: true
```

### Reference
|Key|Type|Required|Default|Summary|
|--|--|--|--|--|
|`name`|String|Yes|(none)|Name of the target instance to create/destroy|
|`host`|String|Yes|(none)|Name of the existing OBSD FSA `virt` host|
|`type`|String|Yes|(none)|Name of the existing `virt.vms` template to use|
|`bootstrap`|Bool|No|`true`|Whether to install python3 on the instance|
|`updates`|Bool|No|`false`|Whether to update the instance|

([Full Reference here](docs/REFERENCE.md))

### See Also
 - [virt](../../roles/virt)
 - [vms](../../roles/vms)
