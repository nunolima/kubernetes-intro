#!/bin/bash

#
# Kubernetes Intro - Setup script
#

sudo apt-get update && \
    sudo apt-get -y install \
        lsb-release \
        curl \
        wget \
        dnsutils \
        net-tools \
        tree \
        vim \
        apt-transport-https \
        ca-certificates \
        bash-completion \
        gnupg-agent \
        software-properties-common \
        && \
    sudo apt-get -y autoclean && \
    sudo apt-get -y autoremove

# remove old docker tools
sudo apt-get -y remove \
    docker \
    docker-engine \
    docker.io \
    containerd \
    runc

# VirtualBox
echo
echo "=========================================================="
echo "Next:"
echo "- Install the right VirtualBox for your linux version from: https://www.virtualbox.org/wiki/Linux_Downloads"
echo "- Add \"VirtualBox Extension Pack\" to your Virtualbox (in File>Preferences>Extensions). Download it from: https://www.virtualbox.org/wiki/Downloads"

