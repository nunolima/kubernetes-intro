# Secret Tips

[secret docs](https://kubernetes.io/docs/concepts/configuration/secret/)

[examples](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/)

```bash
kubectl get secrets --all-namespaces
```

Steps:

```bash
# 1. Convert your secret data to a base-64 representation
echo -n 'user123' | base64
echo -n '39528$vdg7Jb' | base64

# 2. Create a Secret
cat < EOF >> my-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: test-secret
data:
  username: dXNlcjEyMw==
  password: Mzk1MjgkdmRnN0pi
EOF

# 3. Create the secret
kubectl apply -f my-secret.yaml

# 4. list it
kubectl get secret test-secret

# 5. View more detailed
kubectl describe secret test-secret
```

To create a Secret directly with kubectl:

```bash
kubectl create secret generic test-secret --from-literal='username=my-app' --from-literal='password=39528$vdg7Jb'
```

## Example of a Pod that has access to the secret data through a Volume

```bash
# write the pod manifest
cat < EOF >> secret-test-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-test-pod
spec:
  containers:
    - name: test-container
      image: nginx
      volumeMounts:
        # name must match the volume name below
        - name: secret-volume
          mountPath: /etc/secret-volume
  # The secret data is exposed to Containers in the Pod through a Volume.
  volumes:
    - name: secret-volume
      secret:
        secretName: test-secret
EOF

# create the pod
kubectl apply -f secret-test-pod.yaml

# Verify that your Pod is running
kubectl get pod secret-test-pod

# Get a shell into the Container that is running in your Pod
kubectl exec -i -t secret-test-pod -- /bin/bash

# Run this in the shell inside the container
ls /etc/secret-volume
cat /etc/secret-volume/username
cat /etc/secret-volume/password
```

## Define a container environment variable with data from a single Secret

```bash
kubectl create secret generic backend-user --from-literal=backend-username='backend-admin'

cat < EOF >> pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: env-single-secret
spec:
  containers:
  - name: envars-test-container
    image: nginx
    env:
    - name: SECRET_USERNAME
      valueFrom:
        secretKeyRef:
          name: backend-user
          key: backend-username
EOF

kubectl create -f pod.yaml

kubectl exec -i -t env-single-secret -- /bin/sh -c 'echo $SECRET_USERNAME'
```

## Define container environment variables with data from multiple Secrets

```bash
kubectl create secret generic backend-user --from-literal=backend-username='backend-admin'
kubectl create secret generic db-user --from-literal=db-username='db-admin'

cat < EOF >> pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: envvars-multiple-secrets
spec:
  containers:
  - name: envars-test-container
    image: nginx
    env:
    - name: BACKEND_USERNAME
      valueFrom:
        secretKeyRef:
          name: backend-user
          key: backend-username
    - name: DB_USERNAME
      valueFrom:
        secretKeyRef:
          name: db-user
          key: db-username
EOF

kubectl create -f pod.yaml

kubectl exec -i -t envvars-multiple-secrets -- /bin/sh -c 'env | grep _USERNAME'
```

## Configure all key-value pairs in a Secret as container environment variables

```bash
kubectl create secret generic test-secret --from-literal=username='my-app' --from-literal=password='39528$vdg7Jb'

cat < EOF >> pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: envfrom-secret
spec:
  containers:
  - name: envars-test-container
    image: nginx
    envFrom:
    - secretRef:
        name: test-secret
EOF

kubectl create -f https://k8s.io/examples/pods/inject/pod-secret-envFrom.yaml
kubectl exec -i -t envfrom-secret -- /bin/sh -c 'echo "username: $username\npassword: $password\n"'
```

