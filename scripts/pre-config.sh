#!/usr/bin/bash

## Add the archlive user for AUR access
useradd -d /home/archlive -G wheel -p archlive archlive
mkdir /home/archlive
chown archlive /home/archlive

## Add the right items to startup so we have access to our hardware
rc-update add acpid default
rc-update add alsasound default
rc-update add autofs default
rc-update add cronie default
rc-update add cupsd default
rc-update add xdm default
rc-update add fuse default
rc-update add haveged default
rc-update add hdparm default
rc-update add smb default
rc-update add sshd default
rc-update add syslog-ng default
rc-update add udev boot
rc-update add elogind boot
rc-update add dbus boot
