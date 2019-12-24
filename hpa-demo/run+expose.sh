#!/bin/bash
kubectl run my-php-cpu-intensive-app --image=my-php-cpu-intensive-img:latest --requests=cpu=200m --limits=cpu=500m --expose --port=8091
kubectl autoscale deployment my-php-cpu-intensive-app --cpu-percent=50 --min=1 --max=10
kubectl get svc,deploy,hpa -o wide

