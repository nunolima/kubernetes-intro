#!/bin/bash

kubectl run --generator='deployment/apps.v1' cpu-intensive-app --image=cpu-intensive-image --image-pull-policy='IfNotPresent' --requests=cpu=200m --limits=cpu=500m --expose --port=80
# --image-pull-policy='Always' ISSUE: https://stackoverflow.com/questions/46101641/minikube-cant-pull-image-from-local-registry
kubectl autoscale deployment cpu-intensive-app --cpu-percent=50 --min=1 --max=10

kubectl get po -o wide | grep cpu-intensive-app
echo
kubectl get deploy,svc,hpa cpu-intensive-app -o wide

echo
echo "=============== TIPS =============="
echo "kubectl get po -o wide | grep cpu-intensive-app"
echo "kubectl get deploy,svc,hpa cpu-intensive-app -o wide"
echo "kubectl edit deploy cpu-intensive-app"
echo "kubectl delete deploy,svc,hpa cpu-intensive-app"

