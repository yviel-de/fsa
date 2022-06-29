# FSA Command - yviel's FSA `v0.2.0`
This page documents the functionality and feature set of the `fsa` command.

## Table of Contents
 - [Command Reference](#command-reference)
 - [Feature Description](#feature-description)
    - [Config Keys](#config-keys)
    - [Config Args](#config-args)
    - [Dynamic Inventory](#dynamic-inventory)
    - [FSA Tools](#fsa-tools)
    - [Parallel Execution](#parallel-execution)
 - [Documentation](#documentation)

## Feature Description
`fsa` wraps around `ansible-playbook` to provide various extended functionalities.

Since it wraps around `ansible-playbook`, it only works from within an ansible or FSA directory.

This in turn means it can be `alias`ed without any elevated permissions: `alias fsa='sh utils/fsa.sh'`

## Command Reference
```shell
-l [--limit] host1,host2    # limits execution to specific target hosts
-r [--roles] role1,role2    # limits execution to specific roles
-c [--config] role1,role2   # same as --roles
-p [--playbook] myfile.yaml # runs an existing ansible playbook file
-g [--genpass] mypassword   # generate passwords (if none specified) and pwd hashes
-u [--updates]              # perform just system and package updates
-f [--finder] myhost        # run the ethernet fact-finder on a machine
-v [--verbose]              # show more detailed information
-h [--help]                 # display this information
```

#### Config Keys
`fsa` dynamically constructs playbooks on the basis of custom `fsa` config keys.

To achieve this it works in tandem with the special `fsa_connect` role, the shellscript providing functionalities not available with native ansible means.

See the [fsa_connect](../../roles/fsa_connect) role for configuration.

#### Config Args
`fsa` dynamically constructs playbooks on the basis of `--config` (or `--role`) arguments passed on invocation.

These are mapped against all available ansible roles *and their tags*, and only matches are executed.

Any matching role names will be added to the list, any matching tags will be applied to the entire run ie all roles.

#### Dynamic Inventory
`fsa` constructs a dynamic inventory from the contents of the `config/` or `host_vars/` folder.

This only happens if an `inventory` file does not already exist.

It can not yet deal with `group_vars/`.

#### FSA Tools
`fsa` provides custom command-line switches to simplify life of the FSA user:

 * `--genpass` interactively prompts for a host to run against, and produces password hashes
 * `--finder` uses [fsa_finder](../../roles/fsa_finder) to help populate `net.ifaces` configuration
 * `--updates` uses [fsa_update](../../roles/fsa_update) to perform only system and package updates

#### Parallel Execution
`fsa` automatically parallelizes execution to the ratio of 2 targets per CPU core.

## Documentation
Further information can be found in the shellscript itself.
