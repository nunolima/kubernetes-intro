# Namespace Tips

```bash
kubectl get namespaces --show-labels

kubectl config view
kubectl config current-context
# The next step is to define a context for the kubectl client to work in each namespace. The values of “cluster” and “user” fields are copied from the current context.
kubectl config set-context prod --namespace=production --cluster=minikube --user=minikube
kubectl config set-context dev --namespace=production --cluster=minikube --user=minikube

kubectl config use-context dev
kubectl config current-context
kubectl config view

kubectl delete ns development
kubectl delete ns production

```

