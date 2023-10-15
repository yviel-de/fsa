# Development - yviel's FSA v0.3.0
This page contains technical information on FSA.

## Table of Contents
 - [Overview](#overview)
 - [Ansible](#ansible)
 - [Shell](#shell)
 - [Workflow](#workflow)

## Overview
Under the hood, FSA is [ansible](https://www.ansible.com/) code with a good amount of shell inbetween and around.

Design decisions are primarily influcenced by:
 - Simplicity: it should be easy to work with and easy to debug
 - Leanness: it should carry as little baggage as necessary
 - Performance: because ansible is slow

## Ansible
Roles are organized with the `main.yaml` serving as index file for task includes with conditional switches.

Ansible code follows the following rules:
 - Any code must work with only `python3` on the target, only installing python3-foobar in extreme cases.
 - Any code must fit into the existing variable format.
 - Any code must do nothing if no variables are defined.
 - Any `lineinfile`/`blockinfile`s, if unavoidable, must be cleaned up in the same run they were created in.
 - Role cross-dependencies must be as logical and clean as possible.

## Shell
Shell is the perennial text glue. Nuff said.

- Any shell code must be portable enough to run on OpenBSD's `ksh` and Alpine's `ash`.
- Any shell code must be properly documented through code comments.

## Workflow
FSA work items are tracked using Trello, with internal notes and plans in Confluence.

Development happens on a private Gitea instance, supported by infrastructure managed using the Development version.

- A feature branch gets branched off of the main development branch
- The feature gets developed inside of that branch
- On MR to main, it is subjected to the full test suite
- The code is also reviewed and explicitly approved
- On merge to main, the full test suite runs again
- If successful, the code is tagged, and pushed to the public GitHub
- A GitHub Action then triggers to create a new release from that tag

For more information on the automated tests, see [Testing FSA](../molecule/).
