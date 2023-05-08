#!/bin/bash

# Create a new directory for the swap file
sudo mkdir /swap_new

# Create a new 1GB swap file
sudo dd if=/dev/zero of=/swap_new/swapfile bs=1M count=1024

# Set file permissions to ensure only root user can access
sudo chmod 600 /swap_new/swapfile

# Set up the newly created file as a swap area
sudo mkswap /swap_new/swapfile

# Enable the new swap area
sudo swapon /swap_new/swapfile

# Add the swap entry to /etc/fstab
echo "/swap_new/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab
