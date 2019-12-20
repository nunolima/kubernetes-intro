#!/bin/bash

docker build -t minikube-backend-img:1.0 ./backend
#docker run -d --rm -p 8090:8090 --hostname my-backend --name my-backend minikube-backend-img:1.0
#curl $(minikube ip):8090
#curl $(minikube ip):8090/api

