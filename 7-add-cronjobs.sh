#!/bin/bash

# Cronjob definition for deepcool-digital-linux
DEEPCOOL_CRON="@reboot sudo /home/antrax/dotfiles/bin/deepcool-digital-linux > /dev/null 2>&1 & disown"

# Cronjob definition for ethtool (Wake-on-LAN)
ETHTOOL_CRON="@reboot sudo ethtool -s enp8s0 wol g"

# Function to add a cronjob if it doesn't already exist
add_cronjob() {
  local job_to_add="$1"
  # Check if the cronjob already exists in the crontab
  if ! crontab -l | grep -Fq "$job_to_add"; then
    (
      crontab -l
      echo "$job_to_add"
    ) | crontab -
    echo "Cronjob added: $job_to_add"
  else
    echo "Cronjob already exists: $job_to_add"
  fi
}

echo "Adding cronjobs..."

# Add deepcool-digital-linux cronjob
add_cronjob "$DEEPCOOL_CRON"

# Add ethtool cronjob
add_cronjob "$ETHTOOL_CRON"

echo "Cronjob configuration complete."
