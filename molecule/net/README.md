# `net` - yviel's FSA v0.3.0
This test scenario is for the `net` key.

## Table of Contents
  - [DHCP](#dhcp)
    - [Setup](#setup)
    - [Testing](#testing)
  - [DNS](#dns)
    - [Setup](#setup-1)
    - [Testing](#testing-1)
  - [Firewall](#firewall)
    - [Setup](#setup-2)
    - [Testing](#testing-2)
  - [Roles Used](#roles-used)

## General Setup
This includes two virtual machines connected by `net`

## DHCP
#### Setup
A DHCP server is set up with a single assignable IP address on second machine.
The first machine will retrieve its VLAN interface's address from the server.

#### Testing
Tests if the DHCP client can be pinged from DHCP server.

## DNS
#### Setup
A DNS resolver is set up on second machine to listen to all interfaces. It has a configured whitelist.
The first machine will query all its DNS records from the DNS resolver. The queries will be blocked by the resolver.

#### Testing
Tests if:
- Whitelisted addresses are accessible
- Adservices are blocked
- Client is unable to query for DNS records

## Firewall
#### Setup
Firewall is set up on second machiine to block any outgoing request to certain address.

#### Testing
Tests if request can be made to the host with the blocked IP address.

## Roles Used

- [net](../../roles/net)
- [dhcp](../../roles/dhcp)
- [dns](../../roles/dns)
- [fw](../../roles/fw)
- [filter](../../roles/filter)
