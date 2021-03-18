# services

[source](https://kubernetes.io/docs/concepts/services-networking/service/)

Example of a service of type: ExternalName

```bash
cat << EOF > my-external-name.svc.yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
  namespace: prod
spec:
  type: ExternalName
  externalName: my.database.example.com
EOF
```

