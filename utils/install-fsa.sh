#!/bin/bash
#
# installs the necessary dependencies and prerequisites
# tested on debian, alpine, openbsd
# should also work elsewhere if pip is already installed
# use at your own risk
#
# optional parameter: --dev to install dev dependencies
#

if [ "$1" != "please" ]; then
    cat << EOF
USAGE: install-fsa.sh please [--dev]

    This utility installs packages and appends to your shell config, hence the mandatory "please"

    "--dev" may be indicated to also install the necessary dependencies to test fsa
EOF
    exit 0
fi

# check if we're in an fsa dir
if ! [ -d ./roles ]; then
    echo "Please run from the main folder"
    exit 1
fi

if [ "$2" = "--dev" ]; then
    dev="--dev"
else
    dev=""
fi

# check if we need to get pip
if ! which pip >/dev/null; then
    # privesc check
    if ! [ "$(whoami)" = "root" ]; then
        if [ "$(uname)" = "Linux" ]; then
            sudo="sudo"
        else
            sudo="doas"
        fi
    else
        sudo=""
    fi
    # install pip on common platforms
    if which apt >/dev/null; then
        # debian & ubuntu
        $sudo apt update
        $sudo apt install --yes --no-install-recommends python3-pip
    elif which apk >/dev/null; then
        # alpine
        $sudo apk add py3-pip
    elif which pkg_add >/dev/null; then
        # openbsd
        $sudo pkg_add py3-pip
    elif which dnf >/dev/null; then
        # fedora & redhat
        $sudo dnf install --assumeyes python3-pip
    elif which pacman >/dev/null; then
        # arch
        echo '' | $sudo pacman -Sy python-pip
    elif [ "$(uname)" = "Darwin" ]; then
        # macos comes with python
        $sudo python3 -m ensurepip
    else
        echo "Couldn't determine package manager."
        echo "Please install pip and run again."
        exit 1
    fi
fi

# secret undocumented parameter so i don't have to remember things
# in development the configs are in a separate repo linked in via git submodule
# in order to not give contributors access to my personal configs
# after all, not everybody is so fortunate as to have testing separate from production
if [ "$3" = "--admin" ]; then
    git submodule add -b master ssh://gitea@vcs.opviel.de:2223/opv/ansible.git ./config
fi

# create configdir, this is also done by build-fsa.sh
[ ! -d ./config ] && cp ./docs/CONFIG.md ./config/README.md

# use pip to get pipenv
pip3 install --user --upgrade pipenv
# then get all the necessary dependencies
if [ "$dev" != "" ]; then
    pipenv install --dev
else
    pipenv install -r utils/requirements.txt
fi
# and clear caches
pipenv --clear

# set the fsa shell alias
shellname="$(echo $SHELL | rev | cut -d '/' -f1 | rev)"
line="alias fsa='sh utils/fsa.sh'"
file=$(find ~/ -type f -maxdepth 0 | grep "$shellname" | grep -E "rc$|profile$"|head -1)
if ! grep -q "$line" "$file"; then
    echo "$line" >> "$file"
    source "$file"
fi

echo "---"
echo "Done"
