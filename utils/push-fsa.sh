#!/bin/bash
#
# CICD helper utility to publish FSA to another repo
# it assumes the FSA dev repo is checked out and we are in the middle of it
#
# it expects $reponame and $remotename to already be set!
# export reponame='my-git-repo'
# export remotename='ssh://user@github.com/org'
#
# requires git and rsync
#

# if called with --fsa argument, enforces FSA git release scheme:
# source:any --> staging:any
# source:master --> staging:main && public:main
# + read version from CHANGELOG.md & add tag

function usage {
    cat << EOF
Example Usage:
    export reponame="testrepo"
    export remotename="git@github.com:my-user"
    sh utils/push-fsa.sh --fsa

    "--fsa" will enforce FSA git branch release scheme:
    source:any --> staging:any
    source:master --> staging:main && prod:main
    It will read the latest version number from docs/CHANGELOG.md
    and auto-tag the commit on the prod repo

    Expects \$reponame and \$remotename to already be set.
EOF
    exit 0
}

[ "$reponame" != "" ] || [ "$remotename" != "" ] || usage

if ! which git rsync >/dev/null; then
    echo "Error: Requires git and rsync to be installed"
    exit 1
fi

# username to use in git commits
gituser="pipeline"
# mail addr to use in git commits
gitemail="pipeline@yviel.de"
# whitelist for allowed staging repos, only relevant for --fsa
# everything else is considered production
stagingrepo="fsa-staging"

# assumes we're in the root of the repo
pwd="$(pwd)"

lastcommit=$(git log -1 --pretty=%B)
hostbranch=$(git rev-parse --abbrev-ref HEAD)

# for some reason doesnt work with condition, so do with grep instead
if [ "$1" != "--fsa" ] || [ "$hostbranch" != "master" ]; then
    # use same target branch as origin
    targetbranch="$hostbranch"

elif [ "$1" == "--fsa" ]; then
    fsa_version_string=$(grep -E '^\#+ v[0-9]+.[0-9]+.[0-9]' docs/CHANGELOG.md | cut -d ' ' -f2 | sort | tail -1)

    # if the version strings ends in -dev, don't push to master
    if [ "$(echo $fsa_version_string | cut -d '-' -f2)" = "dev" ]; then
        isdev="true"
    else
        isdev="false"
    fi

    if [ "$stagingrepo" == "$reponame" ]; then
        devpush="true"
    else
        devpush="false"
    fi

    if [ "$isdev" == "true" ] && [ "$devpush" == "false" ]; then
        echo "Target repo not matching staging repos whitelist, but version number is -dev. Aborting."
        exit 0

    elif [ "$hostbranch" == "master" ]; then
        targetbranch="main"
    fi
fi

# clone the release repo
cd "$(mktemp -d)"
GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no" git clone "$remotename/$reponame.git" ./

# check out branch, set identity
# determine if $firstpush
if ! git checkout "$targetbranch" >/dev/null 2>&1; then
    firstpush=true
    git checkout -b "$targetbranch"
fi
git config user.name "$gituser"
git config user.email "$gitemail"
# copy over everything, exclude pipeline artifacts and such
rsync -avzl --delete \
    --exclude=.git \
    --exclude=.gitmodules \
    --exclude=.env \
    --exclude=Pipenv \
    --exclude=Pipenv.lock \
    "$pwd"/ ./

if [ ! -f utils/requirements.txt ]; then
    # something went wrong at an earlier stage
    echo "Missing requirements.txt. Abort."
    exit 1
fi

# tag sanity checks
# this is also a way to do manual release control through removal of -dev prefix
if [ "$devpush" == "false" ]; then
    git tag | grep -q "$fsa_version_string" \
    && echo "Version $fsa_version_string already exists. Aborting." \
    && exit 1
fi

# commit and push away
git add .
set +e  # git status doesn't return checkable exit code
git commit . -m "$lastcommit"
set -e

if [ "$firstpush" == "true" ]; then
    GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no" git push --set-upstream origin "$targetbranch"
else
    GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no" git push
fi
if [ "$devpush" == "false" ]; then
    # we don't push tags on nonprod to avoid conflicts and errors
    git tag -a "$fsa_version_string" -m "$lastcommit"
    GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no" git push --tags
fi
