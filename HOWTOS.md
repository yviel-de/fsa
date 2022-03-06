# HowTos - yviel's FSA `v0.1.0`
HowTos for "common" things which might not be common to you.

 - [Fulfilling the Target Prerequisites](#fulfilling-the-target-prerequisites)
    - [System](#system)
        - [No admin user](#if-you-havent-added-a-non-root-user-during-install)
        - [No sudo/doas](#if-your-user-doesnt-have-sudo-doas)
        - [No python](#if-python-is-not-installed)
    - [Network](#network)
        - [No Name resolution](#if-you-have-to-enter-an-ip-or-a-fully-qualified-domain-name)
        - [Different user or port](#if-you-have-to-specify-the-user-or-port)
        - [No ssh-keys](#if-ssh-myhostname-asks-you-for-a-password)
 - [I don't have a VPS or Domain](#i-dont-have-a-vps-or-domain)
 - [I don't have Linux Tooling](#i-dont-have-linux-tooling)
    - [Windows](#on-windows)
    - [MacOS](#on-macos)
    - [In a VM](#in-a-vm)

## Fulfilling the Target Prerequisites
The servers which you configure and manage through FSA must:
 1. run OpenBSD (for now)
 2. be reachable through SSH
    a) through a key not a password
    b) without having to specify user, domain/IP or port
 3. into a user that is *not* `root`
    a) with full sudo/doas privileges
 4. and have `python3` installed.

### System
#### If you haven't added a non-root user during install
 * OpenBSD as root: `adduser`

#### If you haven't enabled the SSH server on install
 * OpenBSD as root: `rcctl enable sshd && rcctl start sshd`

#### If your user doesn't have sudo/doas
FSA requires a regular user with full sudo/doas privileges.
 * OpenBSD as root: `echo "permit nopass myusername" | tee -a /etc/doas.conf`

#### If python is not installed
eg `which python3` doesn't return `/usr/local/bin/python3`
 * OpenBSD as root: `pkg_add python3`

### Network
FSA requires you to be able to simply `ssh mytarget`, without password or having to specify address, user or port.

#### If you have to enter an IP or a Fully Qualified Domain Name:
eg. `ssh 10.20.30.40` or `ssh myhostname.domain.com`
Put something like this in your local `/etc/hosts`:

`10.20.30.40 myhostname`

#### If you have to specify the User or Port
eg. `ssh myuser@myhostname` or `ssh -p 2222 myhostname`, put something like this in your local `~/.ssh/config`:
```
Host myhostname
    User myremoteuser
    Port 2222
```
#### If `ssh myhostname` asks you for a password
Generate a SSH key and put the pubkey into the target's `authorized_keys`.
```
ssh-keygen -t rsa -b 8192
cat .ssh/id_rsa.pub | ssh myhostname 'mkdir .ssh; cat >> .ssh/authorized_keys'
```

## I don't have a VPS or Domain
You can get a VPS virtually everywhere. For OpenBSD go to [obsd.ams](https://openbsd.amsterdam), popular international providers are [linode](https://www.linode.com), [vultr](https://www.vultr.com) and [digitalocean](https://www.digitalocean.com).

Your domain registrar should be separate from your VPS provider, as some providers like to use them as leverage to make it hard for you to leave.

You can get domains at places like [INWX](https://www.inwx.com), [Namecheap](https://www.namecheap.com), and of course your country's registrars. Avoid GoDaddy.

## I don't have Linux Tooling

#### On Windows:

On Windows you can use WSL, the Windows Subsystem for Linux:

Go to the store and install [Debian](https://www.microsoft.com/en-us/p/debian/9msvkqc78pk6).

#### On MacOS:

 - Set up [brew](https://brew.sh)
 - run `sudo brew install --cask iterm2`
 - use iTerm2 instead of Terminal from this point on
 - and proceed from there :)

#### In a VM (either):

If you cannot use WSL or `brew`, set up a VM instead using either [VirtualBox](https://www.virtualbox.org/wiki/Downloads) or [VMWare Player](https://www.vmware.com/go/downloadplayer).

Note that if you do this, you *can* also download and install [OpenBSD](https://cdn.openbsd.org/pub/OpenBSD/7.0/amd64/install70.iso) and run FSA against `localhost`, eg itself.

