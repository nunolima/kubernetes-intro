# Horizontal Pod Autoscaler Walkthrough Demo

[docs](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough)

[video](https://www.youtube.com/watch?v=7DByxtY0Jdg)

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

Build the cpu-intensive-image running:
```bash
./docker-build.sh
```

Deploy the "cpu-intensive-app" in minikube with:
```
./create-hpa.sh
```

Monitor our "cpu-intensive-app" usage and apply load to it;
Open 4 shell terminals and run on each the following commands.
```bash
# On terminal 1
watch kubectl get hpa cpu-intensive-app -o wide

# On terminal 2
watch kubectl get pods -l run=cpu-intensive-app -o wide

# On terminal 3
watch kubectl top pod -l run=cpu-intensive-app

# On terminal 4
kubectl run --generator=run-pod/v1 -it --rm load-generator --image=busybox /bin/sh
# Inside the container pod call:
while true; do wget -q -O- http://cpu-intensive-app.default.svc.cluster.local; done
# CTRL+C to cancel load; exit to terminate container.
```
