#!/bin/bash

#
# Kubernetes Intro - Setup script 04-KUBECTL
#

# kubectl
sudo curl -L https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl
sudo chmod +x /usr/local/bin/kubectl
sudo ln -s /usr/local/bin/kubectl /usr/bin/kubectl
sudo sh -c 'echo "source <(kubectl completion bash)" >> /etc/bash_completion.d/kubectl'
source /etc/bash_completion
kubectl version

