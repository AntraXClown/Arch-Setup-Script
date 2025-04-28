#!/bin/bash

source functions.sh

echo "Enable Chaotic-AUR repository..."
enableChaoticAur

sudo cp pacman.conf /etc/pacman.conf
echo "OK!"
