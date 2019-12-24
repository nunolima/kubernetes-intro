# Horizontal Pod Autoscaler Walkthrough Demo

[docs](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough)

## Step-by-step
The "metrics-server" monitoring needs to be deployed in the cluster to provide metrics via the resource metrics API, as Horizontal Pod Autoscaler uses this API to collect metrics.
```bash
# https://github.com/kubernetes-sigs/metrics-server
# On minikube if we enable the "metrics-server" addon it will install metric-server@v0.2.1 
minikube addons enable metrics-server
minikube addons list
# If we like to install a newer version of metrics-server an we are using minikube we should disable the addon frist.
minikube addons disable metrics-server
minikube delete
minikube start --extra-config=kubelet.authentication-token-webhook=true
git clone https://github.com/kubernetes-sigs/metrics-server.git
kubectl create -f metrics-server/deploy/1.8+/
# edit metric-server deployment to add the flags
# args:
# - --kubelet-insecure-tls
# - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
kubectl edit deploy -n kube-system metrics-server
```

