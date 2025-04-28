#!/bin/bash

source functions.sh

echo "Install virt-manager"
enableChaoticAur

sudo cp pacman.conf /etc/pacman.conf
echo "OK!"
