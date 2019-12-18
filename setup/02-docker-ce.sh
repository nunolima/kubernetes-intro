#!/bin/bash

#
# Kubernetes Intro - Setup script 02-DOCKER-CE
#

CODENAME=$(lsb_release -cs)

# docker-ce
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

if [ $CODENAME == 'eoan' ]; then
	sudo add-apt-repository \
           "deb [arch=amd64] https://download.docker.com/linux/ubuntu disco stable"
else
	sudo add-apt-repository \
	   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	   $(lsb_release -cs) \
	   stable"
fi

sudo apt-get update && \
sudo apt-get -y install docker-ce docker-ce-cli containerd.io
sudo apt-mark hold docker-ce docker-ce-cli containerd.io
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
mkdir -p /home/"$USER"/.docker
sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
sudo chmod g+rwx "$HOME/.docker" -R
sudo systemctl enable docker
