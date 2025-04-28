#!/bin/bash

echo "Enable sddm.conf..."
sudo mkdir /etc/sddm.conf.d
sudo cp autologin.conf /etc/sddm.conf.d/autologin.conf
sudo systemctl enable sddm
echo "OK"
