# `utils` - yviel's FSA v0.3.0
This folder contains various scripts and configuration files, for which this page serves as an index.

## Table of Contents
 - [Scripts](#scripts)
 - [Files](#files)

## Scripts
 - `build-fsa.sh`: used to clean and package FSA up for release.
 - `docs-fsa.sh`: used to check the documentation against dead links, missing references etc.
 - `fsa.sh`: the main FSA script wrapping around `ansible-playbook`. [See here for details](../docs/FSA_CMD.md).
 - `install-fsa.sh`: used to install FSA dependencies.
 - `push-fsa.sh`: used to push FSA to a different remote repository.
 - `test-fsa.sh`: used to lint the codebase and help ensure that FSA does what it should do
 - `vagrant-fsa.sh`: used to create vagrantboxes out of libvirt VMs, for molecule purposes

All scripts return a usage description when executed without parameters.

## Files
 - `ansible-lint`: configuration file used by `test-fsa.sh` to lint FSA.
 - `ansible.cfg`: global ansible config file, to be fine-tuned.
 - `drone.star`: configuration file for the CI/CD pipeline.
 - `README.md`: this file you're reading right now...
 - `requirements.txt`: meta-information necessary for [installing FSA](../docs/INSTALL.md).
