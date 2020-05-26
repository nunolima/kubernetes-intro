# ResourceQuotas
[sourcer](https://cloud.google.com/blog/products/gcp/kubernetes-best-practices-resource-requests-and-limits)
[docs](https://kubernetes.io/docs/concepts/policy/resource-quotas/)

In an ideal world, Kubernetes Container settings would be good enough to take care of everything, but the world is a dark and terrible place. People can easily forget to set the resources, or a rogue team can set the requests and limits very high and take up more than their fair share of the cluster.

To prevent these scenarios, you can set up ResourceQuotas and LimitRanges at the Namespace level.

After creating Namespaces, you can lock them down using ResourceQuotas. ResourceQuotas are very powerful, but let’s just look at how you can use them to restrict CPU and Memory resource usage.

A Quota for resources might look something like this:

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: demo
spec:
  hard:
    requests.cpu: 500m
    requests.memory: 100Mib
    limits.cpu: 700m
    limits.memory: 500Mib
```

Looking at this example, you can see there are four sections. Configuring each of these sections is optional.

requests.cpu is the maximum combined CPU requests in millicores for all the containers in the Namespace. In the above example, you can have 50 containers with 10m requests, five containers with 100m requests, or even one container with a 500m request. As long as the total requested CPU in the Namespace is less than 500m!

requests.memory is the maximum combined Memory requests for all the containers in the Namespace. In the above example, you can have 50 containers with 2MiB requests, five containers with 20MiB CPU requests, or even a single container with a 100MiB request. As long as the total requested Memory in the Namespace is less than 100MiB!

limits.cpu is the maximum combined CPU limits for all the containers in the Namespace. It’s just like requests.cpu but for the limit.

limits.memory is the maximum combined Memory limits for all containers in the Namespace. It’s just like requests.memory but for the limit.

If you are using a production and development Namespace (in contrast to a Namespace per team or service), a common pattern is to put no quota on the production Namespace and strict quotas on the development Namespace. This allows production to take all the resources it needs in case of a spike in traffic.

## LimitRange
You can also create a LimitRange in your Namespace. Unlike a Quota, which looks at the Namespace as a whole, a LimitRange applies to an individual container. This can help prevent people from creating super tiny or super large containers inside the Namespace.

A LimitRange might look something like this:
```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: demo
spec:
  limits:
  - default:
      cpu: 600m
      memory: 100Mib
    defaultRequest:
      cpu: 100m
      memory: 50Mib
    max:
      cpu: 1000m
      memory: 200Mib
    min:
      cpu: 10m
      memory: 10Mib
    type: Container
```

Looking at this example, you can see there are four sections. Again, setting each of these sections is optional.

The default section sets up the default limits for a container in a pod. If you set these values in the limitRange, any containers that don’t explicitly set these themselves will get assigned the default values.

The defaultRequest section sets up the default requests for a container in a pod. If you set these values in the limitRange, any containers that don’t explicitly set these themselves will get assigned the default values.

The max section will set up the maximum limits that a container in a Pod can set. The default section cannot be higher than this value. Likewise, limits set on a container cannot be higher than this value. It is important to note that if this value is set and the default section is not, any containers that don’t explicitly set these values themselves will get assigned the max values as the limit.

The min section sets up the minimum Requests that a container in a Pod can set. The defaultRequest section cannot be lower than this value. Likewise, requests set on a container cannot be lower than this value either. It is important to note that if this value is set and the defaultRequest section is not, the min value becomes the defaultRequest value too.


