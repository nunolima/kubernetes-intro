#!/bin/bash

#
# Kubernetes Intro - Setup script 05-MINIKUBE
#

# minkube
sudo curl -L https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 -o /usr/local/bin/minikube
sudo chmod +x /usr/local/bin/minikube
sudo ln -s /usr/local/bin/minikube /usr/bin/minikube
sudo sh -c 'echo "source <(minikube completion bash)" >> /etc/bash_completion.d/minikube'
source /etc/bash_completion
minikube update-check
