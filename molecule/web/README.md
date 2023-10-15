# `web` - yviel's FSA v0.3.0
This test scenario is for the `web` key.

## Table of Contents
  - [HTTP-Relay](#http-relay)
    - [Setup](#Setup)
    - [Testing](#Testing)
  - [Roles Used](#roles-used)


## General Setup

This includes two virtual machines connected by `net`

## HTTP-Relay
#### Setup
An HTTP webserver is setup on one machine listening on port 8080.
A Relay service is setup on another machine listening on port 80, which will forward all requests to the HTTP webserver.


#### Testing
Tests if HTTP connection can be made to the HTTP webserver from the relay server. Verifying the services are running properly on the correct ports.


## Roles Used

- [web](../../roles/web)
- [net](../../roles/net)
- [relay](../../roles/relay)
