# FSA Command - yviel's FSA v0.3.0
This page documents the functionality and feature set of the `fsa` command.

## Table of Contents
 - [Command Reference](#command-reference)
 - [Feature Description](#feature-description)
    - [Config Keys](#config-keys)
    - [Config Args](#config-args)
    - [Dynamic Inventory](#dynamic-inventory)
    - [FSA Tools](#fsa-tools)
    - [Parallel Execution](#parallel-execution)
 - [More Information](#more-information)

## Feature Description
`fsa` wraps around `ansible-playbook` to provide various extended functionalities.

Since it works the way it does, it only does so from within an ansible or FSA directory.

## Command Reference
```shell
-l [--limit] host1,host2    # limits execution to specific target hosts
-r [--roles] role1,role2    # limits execution to specific roles (or tags, see below)
-c [--config] role1,role2   # same as --roles
-p [--playbook] myfile      # runs playbooks/myfile.yml (hosts only, no k8s)
-g [--genpass] mypassword   # generate passwords (if none specified) and pwd hashes
-u [--updates]              # perform just system and package updates
-f [--finder] host1,host2   # run the ethernet fact-finder on a machine
-v [--verbose]              # show more detailed information during the run
-h [--help]                 # display this information
--debug                     # print debug info
```

#### Config Keys
`fsa` dynamically constructs playbooks on the basis of custom `fsa` config keys.

To achieve this it works in tandem with the special `fsa_connect` role, the shellscript providing functionalities not available with native ansible means.

See [fsa_connect](../../roles/fsa_connect) for configuration.

#### Config Args
`fsa` dynamically constructs playbooks on the basis of `--config` (or `--role`) arguments passed on invocation.

These are mapped against all available roles, and only matches are executed.

Advanced users will want to know that *ansible tags are also matched*. More information on that behavior is available in `fsa.sh`'s source code.

#### Dynamic Inventory
`fsa` constructs a dynamic inventory from the contents of the `config/` or `host_vars/` folder.

This only happens if an `inventory` file does not already exist.

Advanced users will want to know that `group_vars/` are not yet supported.

#### FSA Tools
`fsa` provides custom command-line switches to simplify life of the FSA user:

 * `--genpass` interactively prompts for a host to run against, and produces password hashes
 * `--finder` uses [fsa_finder](../../roles/fsa_finder) to help populate `net.ifaces` configuration
 * `--updates` uses [fsa_update](../../roles/fsa_update) to perform only system and package updates

#### Parallel Execution
`fsa` automatically parallelizes execution to the ratio of 2 targets per CPU core.

## More Information
Further information can be found in the shellscript itself.
