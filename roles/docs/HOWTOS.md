# HowTos - yviel's FSA `v0.2.0`
HowTos for "common" things which might not be common to you.

## Table of Contents

 - [I don't have Linux Tooling](#i-dont-have-linux-tooling)
    - [On Windows](#on-windows)
    - [On MacOS](#on-macos)
    - [In a VM](#in-a-vm)
 - [I don't have a VPS or Domain](#i-dont-have-a-vps-or-domain)

## I don't have Linux Tooling

#### On Windows:

On Windows you can use WSL, the Windows Subsystem for Linux:

Go to the store and install [Debian](https://www.microsoft.com/en-us/p/debian/9msvkqc78pk6).

#### On MacOS:

 - Set up [brew](https://brew.sh)
 - run `sudo brew install --cask iterm2`
 - close Terminal and open iTerm2
 - then proceed from there :)

#### In a VM (either):

If for some reason you cannot use WSL or `brew`, set up a VM instead using either [VirtualBox](https://www.virtualbox.org/wiki/Downloads) or [VMWare Player](https://www.vmware.com/go/downloadplayer).

Download and install [Debian](debian-11.3.0-amd64-netinst.iso), then proceed from there.

## I don't have a VPS or Domain
You can get a VPS virtually everywhere. For OpenBSD go to [obsd.ams](https://openbsd.amsterdam), for Linux popular international providers are [linode](https://www.linode.com), [vultr](https://www.vultr.com) and [digitalocean](https://www.digitalocean.com).

Your domain registrar should be separate from your VPS provider, as some providers like to use them as leverage to make it hard for you to leave.

You can get domains at places like [INWX](https://www.inwx.com), [Namecheap](https://www.namecheap.com), and of course your country's registrars. *Avoid GoDaddy*.
