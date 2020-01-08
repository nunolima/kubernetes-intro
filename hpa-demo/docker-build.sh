#!/bin/bash
eval $(minikube docker-env)
#eval $(minikube docker-env -u)
docker build -t cpu-intensive-image ./cpu-intensive-image/
echo
eval $(minikube docker-env)
#eval $(minikube docker-env -u)
docker images | grep cpu-intensive-image

echo
echo "=========== TIPS =========="
echo "eval \$(minikube docker-env)"
echo "docker images | grep cpu-intensive-image"
