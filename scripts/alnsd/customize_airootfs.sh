#!/bin/bash

set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

usermod -s /usr/bin/zsh root
chmod 700 /root

sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist

chmod 777 /etc/pacman.d/mirrorlist
chmod 777 /etc/pacman.d/mirrorlist-arch
chmod 777 /etc/pacman.d/mirrorlist-artix

groupadd sudo
groupmod -g 900 sudo
echo "root:toorpassword" | chpasswd
useradd -d /home/archlive -g wheel archlive
echo "archlive:archlive" | chpasswd
usermod -aG sudo archlive

pacman-key --init
pacman-key --populate artix
pacman-key --populate archlinux

chown -R archlive /home/archlive

echo " " >> /etc/sudoers
echo "archlive ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

su archlive -c "yaourt -Sy --noconfirm auto-auto-complete texman netcfg google-chrome-dev yaourt-gui atom-editor-bin zpaq obmenu-generator obmenu"
