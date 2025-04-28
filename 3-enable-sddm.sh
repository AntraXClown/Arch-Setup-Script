#!/bin/bash

echo "Enable sddm.conf..."
sudo cp autologin.conf /etc/sddm.conf.d/autologin.conf
sudo systemctl enable sddm
echo "OK"
