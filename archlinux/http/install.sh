#!/bin/bash

set -eux

/usr/bin/sfdisk /dev/sda <<EOF
label: dos

/dev/sda1 : start=1MiB, type=linux, bootable
EOF

/usr/bin/mkfs.btrfs --force /dev/sda1

/usr/bin/mount --mkdir -o compress=zstd /dev/sda1 /mnt/arch_btrfs
/usr/bin/btrfs subvolume create --parents /mnt/arch_btrfs/@
/usr/bin/btrfs subvolume create --parents /mnt/arch_btrfs/@home
/usr/bin/btrfs subvolume create --parents /mnt/arch_btrfs/@log
/usr/bin/btrfs subvolume create --parents /mnt/arch_btrfs/@pkg
/usr/bin/umount /mnt/arch_btrfs

/usr/bin/mount -o compress=zstd,subvol=@ /dev/sda1 /mnt
/usr/bin/mount --mkdir -o compress=zstd,subvol=@home /dev/sda1 /mnt/home
/usr/bin/mount --mkdir -o compress=zstd,subvol=@pkg /dev/sda1 /mnt/var/cache/pacman/pkg
/usr/bin/mount --mkdir -o compress=zstd,subvol=@log /dev/sda1 /mnt/var/log

/usr/bin/pacstrap -K /mnt \
    base \
    linux \
    linux-firmware \
    btrfs-progs \
    sudo \
    networkmanager \
    openssh \
    grub \
    vim

#/usr/bin/umount --recursive /mnt

exit 0
