#!/bin/bash

#
# Kubernetes Intro - Minikube check
#

echo '============================='

minikube delete
minikube start
#eval $(minikube docker-env)

echo '============================='
kube status

KCONTEXT=$(kubectl config current-context)

if [ $KCONTEXT == 'minikube' ]; then
	echo "==== KCONTEXT: minicube ====="
else
	echo "[ERROR] Kubernetes current-context is ($KCONTEXT)! It should be (minikube)."
	exit -1
fi

kubectl get nodes -o wide
echo '============================='

kubectl run hello-minikube --image=gcr.io/google_containers/echoserver:1.4 --port=8080
kubectl get pods -o wide

for i in {1..150}; do # timeout for 5 minutes
  kubectl get pods 2>&1 | grep 'Running' &> /dev/null
  if [ $? -ne 1 ]; then
    break
  fi
  printf '.'
  sleep 2
done

echo
kubectl get pods -o wide

# expose the pod’s port
kubectl expose deployment hello-minikube --type=NodePort
kubectl get services -o wide

# get the URL of the ‘hello-minikube’ pod
minikube service hello-minikube --url
curl `minikube service hello-minikube --url`

# check the IP address and open ports of all the Minikube pods
kubectl get services -o wide

echo '============================='

minikube status 
# minikube update-context
# minikube dashboard
# kubectl get all -o wide --all-namespaces
# minikube logs
# minikube update-check
# minikube version
# minikube profile
# minikube stop
