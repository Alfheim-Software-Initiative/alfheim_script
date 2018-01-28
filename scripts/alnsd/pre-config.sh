#!/usr/bin/bash

/usr/bin/packages

## Add the archlive user home for AUR access
mkdir -p /home/archlive/{Desktop,Downloads,Music,Pictures,Public,Templates,Videos}

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

## Generate pacman keyrings
pacman-key --init
pacman-key --populate artix
pacman-key --populate archlinux
update-ca-trust

## mkinitcpio runs here
cp /usr/lib/initcpio/hooks/archiso /etc/initcpio/hooks
cp /usr/lib/initcpio/install/archiso /etc/initcpio/install
cp /usr/lib/initcpio/hooks/archiso_shutdown /etc/initcpio/hooks
cp /usr/lib/initcpio/install/archiso_shutdown /etc/initcpio/install
cp /usr/lib/initcpio/hooks/archiso_pxe_common /etc/initcpio/hooks
cp /usr/lib/initcpio/install/archiso_pxe_common /etc/initcpio/install
cp /usr/lib/initcpio/hooks/archiso_pxe_nbd /etc/initcpio/hooks
cp /usr/lib/initcpio/install/archiso_pxe_nbd /etc/initcpio/install
cp /usr/lib/initcpio/hooks/archiso_pxe_http /etc/initcpio/hooks
cp /usr/lib/initcpio/install/archiso_pxe_http /etc/initcpio/install
cp /usr/lib/initcpio/hooks/archiso_pxe_nfs /etc/initcpio/hooks
cp /usr/lib/initcpio/install/archiso_pxe_nfs /etc/initcpio/install
cp /usr/lib/initcpio/hooks/archiso_loop_mnt /etc/initcpio/hooks
cp /usr/lib/initcpio/install/archiso_loop_mnt /etc/initcpio/install

sed -i "s|/usr/lib/initcpio/|/etc/initcpio/|g" /etc/initcpio/install/archiso_shutdown
cp /usr/lib/initcpio/install/archiso_kms /etc/initcpio/install
cp /usr/lib/initcpio/archiso_shutdown /etc/initcpio

mkinitcpio -c /etc/mkinitcpio-archiso.conf -k /boot/vmlinuz-linux -g /boot/alfheim.img

tar xvf /home/archlive/root.tar.gz -C /home/archlive/
tar xvf /home/archlive/root.tar.gz -C /root/
#tar xvf /home/archlive/etc.tar.gz -C /etc/
