#!/bin/bash

set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

usermod -s /usr/bin/zsh root

useradd -m -p "" -g users -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel,disk,sys" -s /usr/bin/zsh archlive

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
su archlive -c "yaourt -Sy --noconfirm auto-auto-complete texman i3lock-fancy-git netcfg google-chrome-dev yaourt-gui ambiance-radiance-colors-suite atom-editor-bin zpaq obmenu-generator obmenu unetbootin gitg-git rust-always-nightly-bin"

tar xvf /root/root.tar.gz -C /home/archlive/
tar xvf /root/root.tar.gz -C /root/

tar pxvf /root/etc.tar.gz -C /etc/
