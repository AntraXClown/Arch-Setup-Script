#!/bin/bash

echo "Enable SDDM service..."

sudo systemctl enable sddm

sudo mkdir /etc/sddm.conf.d
sudo cp autologin /etc/sddm.conf.d/

echo "OK"
