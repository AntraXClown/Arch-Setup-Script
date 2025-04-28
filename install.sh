#!/bin/bash

# Copyright (C) 2021-2024 Thien Tran, Tommaso Chiti
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
#
#the License.

cp mirrorlist /etc/pacman.d/mirrorlist

set -eu

output() {
  printf '\e[1;34m%-6s\e[m\n' "${@}"
}

installation_date=$(date "+%Y-%m-%d %H:%M:%S")

disk_prompt() {
  lsblk
  output 'Please select the number of the corresponding disk (e.g. 1):'
  select entry in $(lsblk -dpnoNAME | grep -P "/dev/nvme|sd|mmcblk|vd"); do
    disk="${entry}"
    output "Arch Linux will be installed on the following disk: ${disk}"
    break
  done
}

username_prompt() {
  output 'Please enter the name for a user account:'
  read -r username

  if [ -z "${username}" ]; then
    output 'Sorry, You need to enter a username.'
    username_prompt
  fi
}

fullname_prompt() {
  output 'Please enter the full name for the user account:'
  read -r fullname

  if [ -z "${fullname}" ]; then
    output 'Please enter the full name of the users account.'
    fullname_prompt
  fi
}

user_password_prompt() {
  output 'Enter your user password (the password will not be shown on the screen):'
  read -r -s user_password

  if [ -z "${user_password}" ]; then
    output 'You need to enter a password.'
    user_password_prompt
  fi

  output 'Confirm your user password (the password will not be shown on the screen):'
  read -r -s user_password2
  if [ "${user_password}" != "${user_password2}" ]; then
    output 'Passwords do not match, please try again.'
    user_password_prompt
  fi
}

hostname_prompt() {
  output 'Enter your hostname:'
  read -r hostname
}

# Set hardcoded variables (temporary, these will be replaced by future prompts)
locale=en_US
kblayout=br-abnt2

# Cleaning the TTY
clear

# Initial prompts
disk_prompt
username_prompt
fullname_prompt
user_password_prompt
hostname_prompt

# Installation

## Updating the live environment usually causes more problems than its worth, and quite often can't be done without remounting cowspace with more capacity
pacman -Sy

## Installing curl
pacman -S --noconfirm curl

## Wipe the disk
sgdisk --zap-all "${disk}"

## Creating a new partition scheme
output "Creating new partition scheme on ${disk}."
sgdisk -g "${disk}"
sgdisk -I -n 1:0:+512M -t 1:ef00 -c 1:'ESP' "${disk}"
sgdisk -I -n 2:0:0 -c 2:'rootfs' "${disk}"

## Informing the Kernel of the changes
output 'Informing the Kernel about the disk changes.'
partprobe "${disk}"

ESP=$(lsblk -no KNAME $disk | awk 'NR==2')
echo "ESP Partition: ${ESP}"
## Formatting the ESP as FAT32
output 'Formatting the EFI Partition as FAT32.'
mkfs.fat -F 32 -s 2 /dev/$ESP

## Formatting the partition as BTRFS
output 'Formatting the rootfs as BTRFS.'
BTRFS='/dev/disk/by-partlabel/rootfs'
mkfs.btrfs -f "${BTRFS}"
mount "${BTRFS}" /mnt

## Creating BTRFS subvolumes
output 'Creating BTRFS subvolumes.'

btrfs su cr /mnt/@
btrfs su cr /mnt/@/.snapshots
mkdir -p /mnt/@/.snapshots/1
btrfs su cr /mnt/@/.snapshots/1/snapshot
btrfs su cr /mnt/@/boot/
btrfs su cr /mnt/@/home
btrfs su cr /mnt/@/root
btrfs su cr /mnt/@/srv
btrfs su cr /mnt/@/var_log
btrfs su cr /mnt/@/var_crash
btrfs su cr /mnt/@/var_cache
btrfs su cr /mnt/@/var_tmp
btrfs su cr /mnt/@/var_spool
btrfs su cr /mnt/@/var_lib_libvirt_images
btrfs su cr /mnt/@/var_lib_machines

## Disable CoW on subvols we are not taking snapshots of
chattr +C /mnt/@/boot
chattr +C /mnt/@/home
chattr +C /mnt/@/root
chattr +C /mnt/@/srv
chattr +C /mnt/@/var_log
chattr +C /mnt/@/var_crash
chattr +C /mnt/@/var_cache
chattr +C /mnt/@/var_tmp
chattr +C /mnt/@/var_spool
chattr +C /mnt/@/var_lib_libvirt_images
chattr +C /mnt/@/var_lib_machines

## Set the default BTRFS Subvol to Snapshot 1 before pacstrapping
btrfs subvolume set-default "$(btrfs subvolume list /mnt | grep "@/.snapshots/1/snapshot" | grep -oP '(?<=ID )[0-9]+')" /mnt

echo "<?xml version=\"1.0\"?>
<snapshot>
  <type>single</type>
  <num>1</num>
  <date>${installation_date}</date>
  <description>First Root Filesystem</description>
  <cleanup>number</cleanup>
</snapshot>" >/mnt/@/.snapshots/1/info.xml

chmod 600 /mnt/@/.snapshots/1/info.xml

## Mounting the newly created subvolumes
umount /mnt
output 'Mounting the newly created subvolumes.'
mount -o ssd,noatime,compress=zstd "${BTRFS}" /mnt
mkdir -p /mnt/{boot,root,home,.snapshots,srv,tmp,var/log,var/crash,var/cache,var/tmp,var/spool,var/lib/libvirt/images,var/lib/machines}

mount -o ssd,noatime,compress=zstd,nodev,nosuid,noexec,subvol=@/boot "${BTRFS}" /mnt/boot
mount -o ssd,noatime,compress=zstd,nodev,nosuid,subvol=@/root "${BTRFS}" /mnt/root
mount -o ssd,noatime,compress=zstd,nodev,nosuid,subvol=@/home "${BTRFS}" /mnt/home
mount -o ssd,noatime,compress=zstd,subvol=@/.snapshots "${BTRFS}" /mnt/.snapshots
mount -o ssd,noatime,compress=zstd,subvol=@/srv "${BTRFS}" /mnt/srv
mount -o ssd,noatime,compress=zstd,nodatacow,nodev,nosuid,noexec,subvol=@/var_log "${BTRFS}" /mnt/var/log
mount -o ssd,noatime,compress=zstd,nodatacow,nodev,nosuid,noexec,subvol=@/var_crash "${BTRFS}" /mnt/var/crash
mount -o ssd,noatime,compress=zstd,nodatacow,nodev,nosuid,noexec,subvol=@/var_cache "${BTRFS}" /mnt/var/cache
mount -o ssd,noatime,compress=zstd,nodatacow,nodev,nosuid,noexec,subvol=@/var_tmp "${BTRFS}" /mnt/var/tmp
mount -o ssd,noatime,compress=zstd,nodatacow,nodev,nosuid,noexec,subvol=@/var_spool "${BTRFS}" /mnt/var/spool
mount -o ssd,noatime,compress=zstd,nodatacow,nodev,nosuid,noexec,subvol=@/var_lib_libvirt_images "${BTRFS}" /mnt/var/lib/libvirt/images
mount -o ssd,noatime,compress=zstd,nodatacow,nodev,nosuid,noexec,subvol=@/var_lib_machines "${BTRFS}" /mnt/var/lib/machines

mkdir -p /mnt/boot/efi
mount -o nodev,nosuid,noexec "/dev/${ESP}" /mnt/boot/efi

## Pacstrap
output 'Installing the base system (it may take a while).'

pacstrap /mnt base git base-devel efibootmgr grub grub-btrfs \
  inotify-tools linux-firmware linux-zen linux-zen-headers amd-ucode neovim \
  reflector snapper snap-pac sudo zram-generator bash networkmanager \
  pipewire-alsa pipewire-pulse pipewire-jack openssh chrony duf gdu

## Generate /etc/fstab
output 'Generating a new fstab.'
genfstab -U /mnt >>/mnt/etc/fstab
sed -i 's#,subvolid=258,subvol=/@/.snapshots/1/snapshot,subvol=@/.snapshots/1/snapshot##g' /mnt/etc/fstab

output 'Setting up hostname, locale and keyboard layout'

## Set hostname
echo "$hostname" >/mnt/etc/hostname

## Setting hosts file
echo 'Setting hosts file.'
echo '# Loopback entries; do not change.
# For historical reasons, localhost precedes localhost.localdomain:
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
# See hosts(5) for proper format and other examples:
# 192.168.1.10 foo.example.org foo
# 192.168.1.13 bar.example.org bar' >/mnt/etc/hosts

## Setup locales
echo "$locale.UTF-8 UTF-8" >/mnt/etc/locale.gen
echo "LANG=$locale.UTF-8" >/mnt/etc/locale.conf

## Setup keyboard layout
echo "KEYMAP=$kblayout" >/mnt/etc/vconsole.conf

## Configure /etc/mkinitcpio.conf
output 'Configuring /etc/mkinitcpio for ZSTD compression.'
sed -i 's/#COMPRESSION="zstd"/COMPRESSION="zstd"/g' /mnt/etc/mkinitcpio.conf
sed -i 's/^MODULES=.*/MODULES=(btrfs)/g' /mnt/etc/mkinitcpio.conf
sed -i 's/^HOOKS=.*/HOOKS=(systemd autodetect microcode modconf keyboard sd-vconsole block)/g' /mnt/etc/mkinitcpio.conf

# Do not preload part_msdos
sed -i 's/ part_msdos//g' /mnt/etc/default/grub

## Ensure correct GRUB settings
echo '' >>/mnt/etc/default/grub
echo '# Booting with BTRFS subvolume
GRUB_BTRFS_OVERRIDE_BOOT_PARTITION_DETECTION=true' >>/mnt/etc/default/grub

## Disable root subvol pinning
## This is **extremely** important, as snapper expects to be able to set the default btrfs subvol
sed -i 's/rootflags=subvol=${rootsubvol}//g' /mnt/etc/grub.d/20_linux_xen

## Kernel hardening
sed -i "s#quiet#root=${BTRFS}#g" /mnt/etc/default/grub



## Remove nullok from system-auth
sed -i 's/nullok//g' /mnt/etc/pam.d/system-auth


## Configuring the system
arch-chroot /mnt /bin/bash -e <<EOF

    # Setting up timezone
    # Temporarily hardcoding here
    ln -sf /usr/share/zoneinfo/America/Fortaleza /etc/localtime

    # Setting up clock
    hwclock --systohc

    # Generating locales
    locale-gen

    # Generating a new initramfs
    chmod 600 /boot/initramfs-linux*
    mkinitcpio -P

    # Installing GRUB
    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --disable-shim-lock

    # Creating grub config file
    grub-mkconfig -o /boot/grub/grub.cfg

    # Adding user with sudo privilege
    useradd -c "$fullname" -m "$username"
    usermod -aG wheel "$username"

    # Snapper configuration
    umount /.snapshots
    rm -r /.snapshots
    snapper --no-dbus -c root create-config /
    btrfs subvolume delete /.snapshots
    mkdir /.snapshots
    mount -a
    chmod 750 /.snapshots
EOF

## Set user password.
[ -n "$username" ] && echo "Setting user password for ${username}." && echo -e "${user_password}\n${user_password}" | arch-chroot /mnt passwd "$username"

## Give wheel user sudo access.
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /mnt/etc/sudoers

## Enable services
systemctl enable chronyd --root=/mnt
systemctl enable fstrim.timer --root=/mnt
systemctl enable grub-btrfsd.service --root=/mnt
systemctl enable reflector.timer --root=/mnt
systemctl enable snapper-timeline.timer --root=/mnt
systemctl enable snapper-cleanup.timer --root=/mnt
systemctl enable systemd-oomd --root=/mnt
systemctl disable systemd-timesyncd --root=/mnt
systemctl enable NetworkManager --root=/mnt
systemctl enable sshd --root=/mnt


# Finish up
echo "Done, you may now wish to reboot (further changes can be done by chrooting into /mnt)."
exit
