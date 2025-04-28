#!/bin/bash

echo "Enable SDDM service..."

sudo systemctl enable sddm

sudo mkdir /etc/sddm.conf.d
sudo cp autologin.conf /etc/sddm.conf.d/

echo "OK"
