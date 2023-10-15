# `Apps` - yviel's FSA v0.3.0
This test scenario is for the `apps` key.

## Table of Contents
  - [Gitea](#gitea)
    - [Setup](#setup)
    - [Testing](#testing)
  - [MySQL](#mysql)
    - [Setup](#setup-1)
    - [Testing](#testing-1)
  - [WebDAV](#webdav)
    - [Setup](#setup-2)
    - [Testing](#testing-2)
  - [MPD](#mpd)
    - [Setup](#setup-3)
    - [Testing](#testing-3)

  - [Roles Used](#roles-used)

## General Setup
Two machines are created, and configured using `net`. Sound is enabled for second machine.

## Gitea
#### Setup
A gitea server is set up on first machine which will listen on all interfaces.

#### Testing
Testing if gitea's webinterface can be accessed through HTTP from second machine.

## MySQL
#### Setup
A MySQL server with a test database and user is set up, which can only be accessed by second machine. The database is imported from a dump file.

#### Testing
Testing if test database's tables list can be retrieved from the the second machine.

## WebDAV
#### Setup
A WebDAV server with a test user is setup to listen on all interfaces.

#### Testing
Testing if HTTP request can be successfully made to the WebDAV server with test user's credentials.

## MPD
#### Setup
An MPD server is set up to listen on localhost. Web radios are setup.

#### Testing
A webradio station is played with a mpd client, testing mpd, audio, and whether or not the playlist files were correctly set up.

## Roles Used

- [base](../../roles/base)
- [net](../../roles/net)
- [mysql](../../roles/mysql)
- [gitea](../../roles/gitea)
- [webdav](../../roles/webdav)
- [mpd](../../roles/mpd)
