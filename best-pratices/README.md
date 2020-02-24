# Kubernetes Best Pratices
[google videos](https://www.youtube.com/watch?v=wGz_cbtCiEA&list=PLIivdWyY5sqL3xfXz5xJvwzFW_tlQB_GB)

## Container gracefull termination
Pod in terminating state (steps):
- The "preStop" hook is executed
- SIGTERM signal is sent to the pod (all containers)
- Kubernetes waits for the "terminationGracePeriodSeconds" (default is 30s) (this period is counted since the "terminating state" starts. It don's wait for preStop or SIGTERM processing time (it's run on parallel).

## Healthchecks: Readiness and Liveness Probes 
2 types of healthchecks:
- Readiness probes: Check if the container network is ready to comunicate with.
- Liveness: If app is Live or Dead. If app is dead t

3 types of probes (for readiness & liveness checks):
- HTTP
- Command
- TCP

### HTTP probes
2xx or 3xx responces are "healthy"
```yaml
spec:
  containers:
  - name: liveness
    livenessProbe:
      httpGet:
        path: /healthz
        port: 8080
```

### Command probes
Run command inside a container. If it returns 0 (zero) it is considered "healthy"
```yaml
spec:
  containers:
  - name: liveness
    livenessProbe:
      exec:
        command:
        - myprogram
```

### TCP probes
It is considered "healthy" if it can establish a connection with the configured port.
```yaml
spec:
  containers:
  - name: liveness
    livenessProbe:
      tcpSocket:
        port: 8080
```

### Configuring Probes
- initialDelaySeconds
- periodSeconds
- timeoutSeconds
- successThreshold
- failureThreshold

The "initialDelaySeconds" is important when using "liveness" to void container restart loops.

## Small Base image sizes
Node.js sample
Dockerfile
```yaml
FROM node:alpine
WORKDIR /app

COPY package.json /app/package.json
RUN npm install --production

COPY server.js /app/server.js
EXPOSE 8080
CMD npm start
```



