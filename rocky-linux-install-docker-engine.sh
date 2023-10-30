#!/bin/bash

# add the docker repository
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# install the needed packages
sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# start and enable the systemd docker service
sudo systemctl --now enable docker


