#!/bin/bash

docker build -t minikube-frontend-img:1.0 ./frontend
#docker run -d --rm -p 8190:80 --hostname my-frontend --name my-frontend minikube-frontend-img:1.0
#curl $(minikube ip):8190
