#!/bin/bash

set -eux

# DEBUG - Get azerty french keyboard in live environment
# loadkeys fr

# DEBUG - For script idempotence
# Make sure the target system root is unmounted in case of previous script issues
# /usr/bin/umount --recursive /mnt

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

/usr/bin/pacstrap -K /mnt --noconfirm --needed \
    base \
    linux \
    linux-firmware \
    btrfs-progs \
    sudo \
    networkmanager \
    openssh \
    grub \
    reflector \
    man-db man-pages \
    vim

genfstab -U /mnt >> /mnt/etc/fstab

/usr/bin/arch-chroot /mnt /bin/bash <<'EOF'

ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=fr" >> /etc/vconsole.conf

echo "archvm" > /etc/hostname

echo "root:vagrant" | chpasswd

useradd -m -s /bin/bash vagrant
echo "vagrant:vagrant" | chpasswd

# Configure vagrant user
mkdir /home/vagrant/.ssh
echo -e "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" \
    >  /home/vagrant/.ssh/authorized_keys
echo -e "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1YdxBpNlzxDqfJyw/QKow1F+wvG9hXGoqiysfJOn5Y vagrant insecure public key" \
    >>  /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/authorized_keys
echo "vagrant ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/vagrant
chmod 440 /etc/sudoers.d/vagrant

grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable systemd-timesyncd.service
systemctl enable NetworkManager.service
systemctl enable sshd.service

EOF

/usr/bin/umount --recursive /mnt
reboot
