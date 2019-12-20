#!/bin/bash

KCONTEXT=$(kubectl config current-context)

if [ $KCONTEXT != 'minikube' ]; then
    echo "[ERROR] This script needs to run on kubernetes minikube context.";
    exit -1;
fi

kubectl apply -f .
kubectl get services -o wide

