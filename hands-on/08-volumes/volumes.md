# Volumes
[docs](https://kubernetes.io/docs/concepts/storage/volumes/)

Types of Volumes

- emptyDir -- not persistent, is erased when a pod is removed;
- EBS (AWS) -- the contents of an EBS volume are persisted and the volume is unmounted. This means that an EBS volume can be pre-populated with data, and that data can be shared between pods;
- [cephfs](https://github.com/kubernetes/examples/tree/master/volumes/cephfs/) -- preserved and the volume is merely unmounted (RWX);
- ConfigMap -- provides a way to inject configuration data into pods;
- Secrets -- is used to pass sensitive information, such as passwords, to Pods;
- [glusterfs](https://www.gluster.org/) -- is a free and open source software scalable network filesystem (RWX);
- NFS -- RWX but, not recommended. Reported many problems with this type (RWX);
- [hostPath](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath) -- mounts a file or directory from the host node's filesystem into your Pod (for single node testing only; WILL NOT WORK in a multi-node cluster; consider using local volume instead);
- [local](https://kubernetes.io/docs/concepts/storage/volumes/#local) -- represents a mounted local storage device such as a disk, partition or directory. Local volumes can only be used as a statically created PersistentVolume. Dynamic provisioning is not supported. This type (not like hostPath) supports node affinity on the PersistentVolume.

## Persistent Volume (pv)
[persistentvolume docs](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)

Each PV contains a spec and status, which is the specification and status of the volume. The name of a PersistentVolume object must be a valid DNS subdomain name.

Kubernetes supports two volumeModes of PersistentVolumes: Filesystem (monted as a directory) and Block (mounted like a raw block device, without any filesystem on it).

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: task-pv-volume
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data"
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv0003
spec:
  capacity:
    storage: 50Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Recycle
  storageClassName: slow
  mountOptions:
    - hard
    - nfsvers=4.1
  nfs:
    path: /tmp
    server: 172.17.0.2
```

Note: In this example, the PersistentVolume is of type NFS (not recommended type) and the helper program /sbin/mount.nfs is required to support the mounting of NFS filesystems.

### Persistent Volume: accessModes

The access modes are:

- (RWO) ReadWriteOnce -- the volume can be mounted as read-write by a single node;
- (ROX) ReadOnlyMany -- the volume can be mounted read-only by many nodes;
- (RWX) ReadWriteMany -- the volume can be mounted as read-write by many nodes.

## Persistent Volume Claim (pvc)

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pv-claim
  labels:
    app: wordpress
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress-mysql
  labels:
    app: wordpress
spec:
  selector:
    matchLabels:
      app: wordpress
      tier: mysql
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: wordpress
        tier: mysql
    spec:
      containers:
      - image: mysql:5.6
        name: mysql
        env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-pass
              key: password
        ports:
        - containerPort: 3306
          name: mysql
        volumeMounts:
        - name: mysql-persistent-storage
          mountPath: /var/lib/mysql
      volumes:
      - name: mysql-persistent-storage
        persistentVolumeClaim:
          claimName: mysql-pv-claim
```

Other [example](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims) of a PVC:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: myclaim
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 8Gi
  storageClassName: slow
  selector:
    matchLabels:
      release: "stable"
    matchExpressions:
      - {key: environment, operator: In, values: [dev]}
```

## Storage Class

Each StorageClass contains the fields provisioner, parameters, and reclaimPolicy, which are used when a PersistentVolume belonging to the class needs to be dynamically provisioned.

Many cluster environments have a default StorageClass installed. When a StorageClass is not specified in the PersistentVolumeClaim, the cluster's default StorageClass is used instead.

When a PersistentVolumeClaim is created, a PersistentVolume is dynamically provisioned based on the StorageClass configuration.

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: standard
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
reclaimPolicy: Retain
allowVolumeExpansion: true
mountOptions:
  - debug
volumeBindingMode: Immediate
---
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: slow
provisioner: kubernetes.io/glusterfs
parameters:
  resturl: "http://127.0.0.1:8081"
  clusterid: "630372ccdc720a92c681fb928f27b53f"
  restauthenabled: "true"
  restuser: "admin"
  secretNamespace: "default"
  secretName: "heketi-secret"
  gidMin: "40000"
  gidMax: "50000"
  volumetype: "replicate:3"
---
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: slow
provisioner: kubernetes.io/aws-ebs
parameters:
  type: io1
  iopsPerGB: "10"
  fsType: ext4
---
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
```

