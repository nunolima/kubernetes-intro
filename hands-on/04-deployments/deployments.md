# Deployment Tips
[deployment docs](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
```bash
kubectl get deployments -o wide
kubectl get deploy -o wide
kubectl get rs -o wide
kubectl get pods

kubectl rollout status deployment.v1.apps/nginx-deployment
kubectl --record deployment.apps/nginx-deployment set image deployment.v1.apps/nginx-deployment nginx=nginx:1.9.1
kubectl set image deployment/nginx-deployment nginx=nginx:1.9.1 --record
kubectl edit deployment.v1.apps/nginx-deployment
kubectl rollout status deployment.v1.apps/nginx-deployment
kubectl describe deployments

kubectl set image deployment.v1.apps/nginx-deployment nginx=nginx:1.91 --record=true
kubectl rollout status deployment.v1.apps/nginx-deployment
kubectl get rs
kubectl get pods


kubectl rollout history deployment.v1.apps/nginx-deployment
kubectl rollout history deployment.v1.apps/nginx-deployment --revision=2

kubectl rollout undo deployment.v1.apps/nginx-deployment
kubectl rollout undo deployment.v1.apps/nginx-deployment --to-revision=2
kubectl get deployment nginx-deployment
kubectl describe deployment nginx-deployment

kubectl scale deployment.v1.apps/nginx-deployment --replicas=10
kubectl autoscale deployment.v1.apps/nginx-deployment --min=10 --max=15 --cpu-percent=80

kubectl set image deployment.v1.apps/nginx-deployment nginx=nginx:sometag

kubectl rollout pause deployment.v1.apps/nginx-deployment
kubectl set image deployment.v1.apps/nginx-deployment nginx=nginx:1.9.1
kubectl rollout history deployment.v1.apps/nginx-deployment
kubectl set resources deployment.v1.apps/nginx-deployment -c=nginx --limits=cpu=200m,memory=512Mi
kubectl rollout resume deployment.v1.apps/nginx-deployment
kubectl get rs -w
kubectl get rs

kubectl rollout status deployment.v1.apps/nginx-deployment

kubectl patch deployment.v1.apps/nginx-deployment -p '{"spec":{"progressDeadlineSeconds":600}}'
```

