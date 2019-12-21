# kubectl Tips

```bash
kubectl run -i --tty --image busybox:1.28 my-bash --restart=Never --rm /bin/sh
kubectl get pod -w -l app=nginx
kubectl delete pod -l app=nginx
kubectl get pvc -l app=nginx

for i in 0 1; do kubectl exec web-$i -- sh -c 'hostname'; done
for i in 0 1; do kubectl exec web-$i -- sh -c 'echo $(hostname) > /usr/share/nginx/html/index.html'; done
for i in 0 1; do kubectl exec -it web-$i -- curl localhost; done
```
