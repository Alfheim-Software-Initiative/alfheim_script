#!/usr/bin/bash

## Please note this code is taken directly from archiso and edited for
## Alfheim Linux, as such this code is licensed under the GNU GPL

set -e -u

## Begin Editable Section
iso_name=alfheim
iso_label="alfheim"
iso_version="BETA2_0.3_2.53"
install_dir=alfheim
work_dir=work
out_dir=out
gpg_key=
iso_publisher="Alfheim Linux <alfheimlinux@gmail.com>"
iso_application="Alfheim Linux Live/Rescue Disk"
## End Editable Section
arch=$(uname -m)
verbose=""

script_path=$(readlink -f ${0%/*})

# Copy scripts/alnsd/etc to root
#cp -rf ${script_path}/skel/etc/* ${work_dir}/airootfs/etc/.

# Prepare kernel/initramfs ${install_dir}
mkdir -p ${work_dir}/iso/${install_dir}/boot/${arch}
cp ${work_dir}/airootfs/boot/alfheim.img ${work_dir}/iso/${install_dir}/boot/${arch}/alfheim.img
cp ${work_dir}/airootfs/boot/vmlinuz-linux ${work_dir}/iso/${install_dir}/boot/${arch}/vmlinuz

# Add other aditional/extra files to ${install_dir}/boot/
cp ${work_dir}/airootfs/boot/memtest86+/memtest.bin ${work_dir}/iso/${install_dir}/boot/memtest
cp ${work_dir}/airootfs/usr/share/licenses/common/GPL2/license.txt ${work_dir}/iso/${install_dir}/boot/memtest.COPYING
cp ${work_dir}/airootfs/boot/intel-ucode.img ${work_dir}/iso/${install_dir}/boot/intel_ucode.img
cp ${work_dir}/airootfs/usr/share/licenses/intel-ucode/LICENSE ${work_dir}/iso/${install_dir}/boot/intel_ucode.LICENSE

# Prepare /${install_dir}/boot/syslinux
mkdir -p ${work_dir}/iso/${install_dir}/boot/syslinux
for _cfg in ${script_path}/syslinux/*.cfg; do
    sed "s|%ARCHISO_LABEL%|${iso_label}|g;
         s|%INSTALL_DIR%|${install_dir}|g" ${_cfg} > ${work_dir}/iso/${install_dir}/boot/syslinux/${_cfg##*/}
done
cp ${script_path}/syslinux/splash.png ${work_dir}/iso/${install_dir}/boot/syslinux
cp ${work_dir}/airootfs/usr/lib/syslinux/bios/*.c32 ${work_dir}/iso/${install_dir}/boot/syslinux
cp ${work_dir}/airootfs/usr/lib/syslinux/bios/lpxelinux.0 ${work_dir}/iso/${install_dir}/boot/syslinux
cp ${work_dir}/airootfs/usr/lib/syslinux/bios/memdisk ${work_dir}/iso/${install_dir}/boot/syslinux
mkdir -p ${work_dir}/iso/${install_dir}/boot/syslinux/hdt
gzip -c -9 ${work_dir}/airootfs/usr/share/hwdata/pci.ids > ${work_dir}/iso/${install_dir}/boot/syslinux/hdt/pciids.gz
gzip -c -9 ${work_dir}/airootfs/usr/lib/modules/*-ARTIX/modules.alias > ${work_dir}/iso/${install_dir}/boot/syslinux/hdt/modalias.gz

# Prepare /isolinux
mkdir -p ${work_dir}/iso/isolinux
sed "s|%INSTALL_DIR%|${install_dir}|g" ${script_path}/isolinux.cfg > ${work_dir}/iso/isolinux/isolinux.cfg
cp ${work_dir}/airootfs/usr/lib/syslinux/bios/isolinux.bin ${work_dir}/iso/isolinux/
cp ${work_dir}/airootfs/usr/lib/syslinux/bios/isohdpfx.bin ${work_dir}/iso/isolinux/
cp ${work_dir}/airootfs/usr/lib/syslinux/bios/ldlinux.c32 ${work_dir}/iso/isolinux/

# Prepare /EFI
mkdir -p ${work_dir}/iso/EFI/boot
cp ${work_dir}/airootfs/usr/share/efitools/efi/PreLoader.efi ${work_dir}/iso/EFI/boot/bootx64.efi
cp ${work_dir}/airootfs/usr/share/efitools/efi/HashTool.efi ${work_dir}/iso/EFI/boot/

cp ${work_dir}/airootfs/usr/share/efitools/efi/Loader.efi ${work_dir}/iso/EFI/boot/loader.efi

mkdir -p ${work_dir}/iso/loader/entries
cp ${script_path}/efiboot/loader/loader.conf ${work_dir}/iso/loader/
cp ${script_path}/efiboot/loader/entries/uefi-shell-v2-x86_64.conf ${work_dir}/iso/loader/entries/
cp ${script_path}/efiboot/loader/entries/uefi-shell-v1-x86_64.conf ${work_dir}/iso/loader/entries/

sed "s|%ARCHISO_LABEL%|${iso_label}|g;
     s|%INSTALL_DIR%|${install_dir}|g" \
    ${script_path}/efiboot/loader/entries/archiso-x86_64-usb.conf > ${work_dir}/iso/loader/entries/archiso-x86_64.conf

# EFI Shell 2.0 for UEFI 2.3+
curl -o ${work_dir}/iso/EFI/shellx64_v2.efi https://raw.githubusercontent.com/tianocore/edk2/master/ShellBinPkg/UefiShell/X64/Shell.efi
# EFI Shell 1.0 for non UEFI 2.3+
curl -o ${work_dir}/iso/EFI/shellx64_v1.efi https://raw.githubusercontent.com/tianocore/edk2/master/EdkShellBinPkg/FullShell/X64/Shell_Full.efi

# Prepare efiboot.img::/EFI for "El Torito" EFI boot mode
mkdir -p ${work_dir}/iso/EFI/archiso
truncate -s 64M ${work_dir}/iso/EFI/archiso/efiboot.img
mkfs.fat -n ARCHISO_EFI ${work_dir}/iso/EFI/archiso/efiboot.img

mkdir -p ${work_dir}/efiboot
mount ${work_dir}/iso/EFI/archiso/efiboot.img ${work_dir}/efiboot

mkdir -p ${work_dir}/efiboot/EFI/archiso
cp ${work_dir}/iso/${install_dir}/boot/x86_64/vmlinuz ${work_dir}/efiboot/EFI/archiso/vmlinuz.efi
cp ${work_dir}/iso/${install_dir}/boot/x86_64/alfheim.img ${work_dir}/efiboot/EFI/archiso/alfheim.img

cp ${work_dir}/iso/${install_dir}/boot/intel_ucode.img ${work_dir}/efiboot/EFI/archiso/intel_ucode.img

mkdir -p ${work_dir}/efiboot/EFI/boot
cp ${work_dir}/airootfs/usr/share/efitools/efi/PreLoader.efi ${work_dir}/efiboot/EFI/boot/bootx64.efi
cp ${work_dir}/airootfs/usr/share/efitools/efi/HashTool.efi ${work_dir}/efiboot/EFI/boot/

cp ${work_dir}/airootfs/usr/share/efitools/efi/Loader.efi ${work_dir}/efiboot/EFI/boot/loader.efi

mkdir -p ${work_dir}/efiboot/loader/entries
cp ${script_path}/efiboot/loader/loader.conf ${work_dir}/efiboot/loader/
cp ${script_path}/efiboot/loader/entries/uefi-shell-v2-x86_64.conf ${work_dir}/efiboot/loader/entries/
cp ${script_path}/efiboot/loader/entries/uefi-shell-v1-x86_64.conf ${work_dir}/efiboot/loader/entries/

sed "s|%ARCHISO_LABEL%|${iso_label}|g;
     s|%INSTALL_DIR%|${install_dir}|g" \
    ${script_path}/efiboot/loader/entries/archiso-x86_64-cd.conf > ${work_dir}/efiboot/loader/entries/archiso-x86_64.conf
#cp -rf ${script_path}/skel/root/.* ${work_dir}/airootfs/root/.
#cp -rf ${script_path}/skel/root/.* ${work_dir}/airootfs/archlive/.

cp ${work_dir}/iso/EFI/shellx64_v2.efi ${work_dir}/efiboot/EFI/
cp ${work_dir}/iso/EFI/shellx64_v1.efi ${work_dir}/efiboot/EFI/

umount -d ${work_dir}/efiboot

# Build airootfs filesystem image
cp -a -l -f ${work_dir}/airootfs ${work_dir}
setarch ${arch} mkarchiso ${verbose} -w "${work_dir}" -P "${iso_publisher}" -A "${iso_application}"  -D "${install_dir}" pkglist
setarch ${arch} mkarchiso ${verbose} -w "${work_dir}" -P "${iso_publisher}" -A "${iso_application}"  -D "${install_dir}" ${gpg_key:+-g ${gpg_key}} prepare
rm -rf ${work_dir}/airootfs
# rm -rf ${work_dir}/${arch}/airootfs (if low space, this helps)

# Build ISO
mkarchiso ${verbose} -w "${work_dir}" -D "${install_dir}" -L "${iso_label}" -P "${iso_publisher}" -A "${iso_application}"  -o "${out_dir}" iso "${iso_name}-${iso_version}-x86_64.iso"
