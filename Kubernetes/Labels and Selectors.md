## [Label selectors](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#label-selectors)

#### Caution:

For both equality-based and set-based conditions there is no logical _OR_ (`||`) operator. Ensure your filter statements are structured accordingly.

### [Equality-based requirement](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#equality-based-requirement)

```
environment = production
tier != frontend
```

The former selects all resources with key equal to `environment` and value equal to `production`. The latter selects all resources with key equal to `tier` and value distinct from `frontend`, and all resources with no labels with the `tier` key.

## [API](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#api)

### [Set references in API objects](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#set-references-in-api-objects)

Some Kubernetes objects, such as [`services`](https://kubernetes.io/docs/concepts/services-networking/service/) and [`replicationcontrollers`](https://kubernetes.io/docs/concepts/workloads/controllers/replicationcontroller/), also use label selectors to specify sets of other resources, such as [pods](https://kubernetes.io/docs/concepts/workloads/pods/).

#### [Resources that support set-based requirements](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#resources-that-support-set-based-requirements)

Newer resources, such as [`Job`](https://kubernetes.io/docs/concepts/workloads/controllers/job/), [`Deployment`](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/), [`ReplicaSet`](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/), and [`DaemonSet`](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/), support _set-based_ requirements as well.
