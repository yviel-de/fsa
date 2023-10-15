#!/bin/bash
#
# small CICD helper script to "package up" FSA
# it assumes the repo is checked out and we are in the middle of it
#

if [ "$1" != "doit" ]; then
    cat << EOF
USAGE: build-fsa.sh doit

    This utility removes and overwrites some files, hence the mandatory "doit"
EOF
    exit 0
fi

# set up config folder
# it's currently a git submodule here so we rm -rf it to have it back as a normal folder
rm -rf ./config/
mkdir ./config/
mv ./docs/CONFIG.md ./config/README.md
# get rid of personal playbooks
rm -rf ./playbooks/*.yml
# also get rid of personal terraform stuffs
rm -rf ./terraform
mkdir ./terraform
# and set up its README.md
mv ./docs/TERRAFORM.md ./terraform/README.md
# quick and dirty hack for the pipeline to only do docs tests
if [ "$2" = "docstests" ]; then
    exit 0
fi

# overwrite the gitignore since i might have temporary changes in the working copy
cat << EOF > .gitignore
# utils/fsa.sh tempfiles
tmp.*
# k8s-helm values files
values-*.yaml
# files from fsa-molecule
molecule/*/molecule.yml
molecule/*/converge.yml
# terraform
terraform/.terraform
EOF

# get rid of testing configs, notes etc
rm -f TODO.txt test.yaml

# grab latest version string from changelog file, replace everywhere
fsa_version_string=$(grep -E '^\#+ v[0-9]+.[0-9]+.[0-9]' docs/CHANGELOG.md | cut -d ' ' -f2 | sort | tail -1)
for i in $(grep -lir FSA_VERSION_STRING * | grep -v build-fsa.sh); do
    sed -i "s|FSA_VERSION_STRING|$fsa_version_string|g" $i
done
## make sure nothing was missed
if find ./ -type f -name '*.md' | xargs grep FSA_VERSION_STRING; then
    echo "string replacement error detected"
    exit 1
fi

# write out galaxy.yml since it can't handle REPLACEMENT_STRING as a version number during development
cat << EOF > ./galaxy.yml
# this file is required in order to be able to install FSA as an ansible collection
namespace: "yviel-de"
name: "fsa"
version: "$(echo $fsa_version_string | tr -d 'v')"
readme: "README.md"
authors:
    - "yviel (https://yviel.de)"
tags:
    - fsa
    - molecule
    - openbsd
    - loadbalancer
    - webserver
    - mail
    - email
    - dhcp
    - dns
    - hypervisor
    - vmd
    - networking
    - vpn
repository: "https://github.com/yviel-de/fsa.git,$fsa_version_string"
EOF

# write out github-actions workflow to make releases out of tags
mkdir -p ./.github/workflows
cat << EOF > ./.github/workflows/main.yml
# This is a GitHub-Actions workflow which makes releases out of tags. You can safely get rid of it.
name: Main
on:
  push:
    tags:
      - '*'
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Release
        uses: softprops/action-gh-release@v1
        if: startsWith(github.ref, 'refs/tags/')
EOF

# write out requirements file
which pipenv >/dev/null && pipenv requirements > utils/requirements.txt
