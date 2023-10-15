# Testing - yviel's FSA v0.3.0
This page contains information on how FSA is tested.

## Table of Contents
  - [Code Tests](#code-tests)
    - [Molecule](#molecule)
    - [test-fsa.sh](#test-fsa-sh)
    - [More Info](#more-info)
    - [Shell](#shell)
  - [Deployment](#deployment)
    - [Drone](#drone)
    - [Chain](#chain)

## Code Tests
#### Molecule
Ansible is tested using the [molecule](https://molecule.readthedocs.io/) framework, primarily because it's the only real option, and I really don't need to reinvent the wheel.

The test scenarios aim to be as comprehensive as possible with regards to testing FSA functionality. They are documented more closely in their respective folders.

Vagrant is used as a backend to provision full VMs, because a non-Linux OS aswell as Networking are involved. A remote Libvirt is used through SSH as a backend.

The test assertions themselves are mostly [testinfra](https://testinfra.readthedocs.io/).

Linting is done using ansible-lint, itself additionally calling yamllint.

#### test-fsa.sh
All of this is automated and abstracted away into `utils/test-fsa.sh`, which performs the following actions:
 - Lint with optional autocorrection attempt
 - Template out `molecule.yml`, `converge.yml` test configs (opt-in)
 - Execute one or more test scenarios

More information can be gathered by executing the script itself without any arguments.

#### Shell
Shell scripts are generally ran against Alpine's `ash`.

## Deployment
#### Drone
Deployments are done using the [Drone](https://docs.drone.io/) CI/CD system, itself making use of the various [`*-fsa.sh` scripts](../utils/) along the way.

While Drone's native language is YAML, this configuration is written in [Starlark](https://docs.drone.io/pipeline/scripting/starlark/) due to its relative size and complexity.

#### Chain
The deployment chain consists of the following steps:
 - Run documentation and other misc tests
 - Run molecule tests against a matrix of OSses
 - Push to staging and/or production repository

The configuration variables at the top of the [pipeline config file](../utils/drone.star) might provide you with further information.

