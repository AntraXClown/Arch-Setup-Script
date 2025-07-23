#!/bin/bash

echo "Install Grub Theme..."

sudo unzip FlatSense.zip -d /boot/grub/themes
sudo sed -i 's|^#GRUB_THEME="/path/to/gfxtheme"|GRUB_THEME="/boot/grub/themes/FlatSense/theme.txt"|' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "OK"
