#!/bin/bash

echo "Enable SDDM service..."

sudo systemctl enable sddm

mkdir /etc/sddm.conf.d
cp autologin /etc/sddm.conf.d/

echo "OK"
