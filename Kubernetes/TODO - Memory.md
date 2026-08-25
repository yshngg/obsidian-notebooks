[How much is too much? The Linux OOMKiller and “used” memory](https://faun.pub/how-much-is-too-much-the-linux-oomkiller-and-used-memory-d32186f29c9d)

The different container memory metrics:

- `container_memory_usage_bytes`
- `container_memory_working_set_bytes`
- `container_memory_rss`

```bash
kubectl create deployment alpine --image=alpine --replicas=1 -- sleep infinity
kubectl set resources deployment/alpine -c alpine --limits=memory=512Mi
```
