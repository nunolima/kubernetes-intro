#!/bin/bash

#
# Kubernetes Intro - Setup script
#

docker version
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

minikube start
eval $(minikube docker-env)

echo '============================='

kubectl run hello-minikube --image=gcr.io/google_containers/echoserver:1.4 --port=8080
kubectl get pods

for i in {1..150}; do # timeout for 5 minutes
  kubectl get pods 2>&1 | grep 'Running' &> /dev/null
  if [ $? -ne 1 ]; then
    break
  fi
  printf '.'
  sleep 2
done

echo
kubectl get pods

# expose the pod’s port
kubectl expose deployment hello-minikube --type=NodePort

# get the URL of the ‘hello-minikube’ pod
minikube service hello-minikube --url
curl `minikube service hello-minikube --url`

# check the IP address and open ports of all the Minikube pods
kubectl get services

echo '============================='

minikube status && \
#	minikube update-context
	minikube dashboard

