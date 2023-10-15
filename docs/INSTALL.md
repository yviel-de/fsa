# Install - yviel's FSA v0.3.0
This page contains install instructions and a quickstart for the impatient ones.

## Table of Contents
 - [Setup](#Setup)
    - [Clone FSA](#clone-fsa)
    - [Save It](#save-it)
    - [Install](#install)
 - [Quickstart](#quickstart)
    - [Configure](#configure)
    - [Execute](#execute)
 - [Maintain](#maintain)
    - [Version Control](#version-control)
    - [Get Updates](#get-updates)

## Setup
You're going to have to install a few packages, most importantly `git`.
 - On Windows: activate [WSL](https://learn.microsoft.com/en-us/windows/wsl/install), get Debian through the store, and use `apt` from there.
 - On Mac: get and use [brew](https://brew.sh/).
 - On Linux/BSD: use your package manager of choice.

If you already have ansible code of your own, you can import FSA as a [collection](https://docs.ansible.com/ansible/latest/collections_guide/index.html): `ansible-galaxy collection install https://github.com/yviel-de/fsa.git,v0.3.0`

If not, continue with the instructions on this page.

#### Clone FSA
Install `git` if you haven't already.

Clone the latest FSA version into a new folder: `git clone --branch v0.3.0 https://github.com/yviel-de/fsa.git`

And enter the new repository of course: `cd fsa`

#### Save It
Rename the FSA remote: `git remote rename origin fsa-upstream`

Create a new, empty (uninitialized), **private** repository of your own.

Select *SSH* when you get to choose the address to clone.

Add it as a new remote: `git remote add origin git@github.com:my-user/my-repo.git`

Switch to your new main branch: `git checkout -b main`

And push it all away: `git push --set-upstream origin main`

#### Install Dependencies
Execute `sh utils/install-fsa.sh`. That should be it.

###### The Manual Way
If you insist on doing it yourself instead, you can:

Install `pip` if you haven't already, then use it to install `pipenv`: `pip install --upgrade pipenv`

Then install the necessary dependencies: `pipenv install -r utils/requirements.txt`

Find your shell startup file: `file=$(ls -a ~/ | grep -E "$SHELL|.profile"|head -1)`

Add the FSA alias to it: `echo "alias fsa='sh utils/fsa.sh'" >> ~/"$file"`

And finally reload the file: `source ~/"$file"`

## Quickstart
Just the basics.

#### Configure
Every server managed by FSA has its own configuration file under `config/server-name`.

Depending on things like whether the host is reachable under `server-name`, the login user is `root` or requires `sudo`/`doas`, `fsa` connection variables will have to be set.

In addition, the system *must* be given a name using `base.name`.

Finally, a lot of FSA functionality hinges on a valid `net` configuration.

[More information about possible configs](../roles)

#### Execute
To execute, you must be in an `fsa` (or ansible) directory, i.E. in the root of the repository.

Simply run `fsa -l all` to watch configuration be applied.

[Information about targeting runs](FSA_CMD.md)

## Maintain
How to keep your FSA installation running and up to date.

#### Version Control
Provided you followed the install instructions, you should be able to easily save your configurations, and any modifications you make to FSA, in your own repository.

`git add . && git commit . -m "I changed this, this and this" && git push`

This not only gives you versioning and history but also access to a whole lot of neat features which unfortunately aren't the topic of this article.

#### Get Updates
Run `git fetch fsa-upstream` to get new meta-information. If a new release was created since your last fetch it will be shown.

If you think you might have missed it, `git tag | sort` will show you all available versions.

To cleanly update to the latest version, perform the following steps:

 a) Make sure any pending changes of yours are saved away: `git status` should return "nothing to commit".

 b) Create a new branch to test the update in: `git checkout -b feature/update-to-latest`

 c) Merge the new v0.3.0 code into your tree: `git merge fsa-upstream v0.3.0`

 d) Resolve any merge conflicts resulting from your own changes to the codebase, and perform any required changes to your configs.

 d) Check the [Changelog](CHANGELOG.md) for inevitable changes that might mess with your configs.

 e) Test the changes in small pieces and submit a bug report if something happens to break.

 f) Push away your changes, `git push origin main` once you are certain that everything is fine, or

 g) If something went wrong, return to your version with `git checkout main`.

