#!/bin/bash

echo "Writing Shares on fstab..."

sudo mkdir /Secondary
sudo chown -R antrax:antrax /Secondary
sudo mkdir /NFS
sudo chown -R antrax:antrax /NFS

echo "192.168.1.24:/ /NFS nfs rw,hard 0 0" | sudo tee -a /etc/fstab
echo "UUID=d03e61af-12c6-46c7-9ac6-216a8661ff93 /Secondary ext4 defaults,noatime 0 2" | sudo tee -a /etc/fstab

echo "OK"
