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
        virtualbox \
        virtualbox-ext-pack \
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

# docker-ce
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
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
#sudo netstat -lntp | grep dockerd

# docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo curl -L https://raw.githubusercontent.com/docker/compose/1.25.0/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
source "$HOME/.bashrc"
docker-compose --version

# minkube
sudo curl -L https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 -o /usr/local/bin/minikube
sudo chmod +x /usr/local/bin/minikube
sudo ln -s /usr/local/bin/minikube /usr/bin/minikube
sudo sh -c 'echo "source <(minikube completion bash)" >> /etc/bash_completion.d/minikube'
source /etc/bash_completion
minikube update-check

# kubectl
sudo curl -L https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl
sudo chmod +x /usr/local/bin/kubectl
sudo ln -s /usr/local/bin/kubectl /usr/bin/kubectl
sudo sh -c 'echo "source <(kubectl completion bash)" >> /etc/bash_completion.d/kubectl'
source /etc/bash_completion
kubectl version

echo '============================='


