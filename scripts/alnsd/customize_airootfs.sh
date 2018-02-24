#!/bin/bash

set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

usermod -s /usr/bin/zsh root

useradd -m -p "" -g users -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel,disk,sys" -s /usr/bin/zsh archlive

tar xvf /root/root.tar.gz -C /home/archlive/
tar xvf /root/root.tar.gz -C /root/

tar pxvf /root/etc.tar.gz -C /etc/

# Create the dbus user if it doesn't exist
#[[ $(check_dbus group) = "" ]] && groupadd -g 81 dbus
#[[ $(check_dbus passwd) = "" ]] && useradd -r -s /sbin/nologin -g 81 -u 81 dbus

#chmod 750 /etc/sudoers.d
#chmod 440 /etc/sudoers.d/g_wheel

#sed -i "s/_DATE_/RC1_0.4.1/" /etc/motd

sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist

echo "root:toorpassword" | chpasswd
echo "archlive:archlive" | chpasswd

pacman-key --init
pacman-key --populate artix
pacman-key --populate archlinux

chown -R archlive /home/archlive

echo " " >> /etc/sudoers
echo "archlive ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo " " >> /etc/sudoers
echo "%wheel  ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

## Install AUR specific packages
su archlive -c "yaourt -Sy --noconfirm auto-auto-complete texman i3lock-fancy-git netcfg google-chrome-dev yaourt-gui ambiance-radiance-colors-suite atom-editor-bin zpaq obmenu-generator obmenu unetbootin gitg-git monodevelop-git"
## Install Rust
su archlive -c "curl https://sh.rustup.rs -sSf | sh"

#tar pxvf /home/archlive/etc.tar.gz -C /etc/
