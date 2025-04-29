#!/bin/bash

source functions.sh

echo "Enable Chaotic-AUR repository..."
enableChaoticAur
sudo cp pacman.conf /etc/pacman.conf
sudo pacman -Syyu
yay -R yay-debug
echo "OK!"
