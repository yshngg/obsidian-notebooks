
### Hook — the painful surprise every SRE has seen

You run `kubectl top node` and see memory that doesn't match `free -m` or `top`. Your autoscaler behavior looks reasonable, but your intuition says the node should be out of memory. Which tool is telling the truth? Which one should you trust? This article explains the root cause of the discrepancy, how Kubernetes collects and exposes node metrics, and what that means for troubleshooting, autoscaling, and capacity planning.

Keywords you’ll see repeatedly: **Kubernetes monitoring**, **kubectl top**, **cgroup vs proc**, **container metrics**, **metrics server**.

---

## Prerequisites

- kubernetes [v1.34.2](https://github.com/kubernetes/kubernetes/tree/v1.34.2)
- metrics-server [v0.8.0](https://github.com/kubernetes-sigs/metrics-server/tree/v0.8.0)
- cAdvisor [v0.53.0](https://github.com/google/cadvisor/tree/v0.53.0)

---

## Summary

As the `kubectl top` documentation states, `kubectl top` is designed for the metrics pipeline used by autoscalers (HPA and VPA), not for a verbatim reflection of raw OS metrics like CPU and memory. Tools such as `free` and `top` read kernel `/proc` data (e.g., `/proc/meminfo`) and present system-level memory accounting. Kubernetes metrics flow from cgroups and are massaged by kubelet/cAdvisor/metrics-server into the `metrics.k8s.io` API; those numbers are tuned to provide stable signals for autoscalers, not to match every detail from `free`/`top`. Therefore the gap between the two is normal and expected — you should use each tool for its intended purpose.

> The metrics shown are specifically optimized for Kubernetes autoscaling decisions, such as those made by the Horizontal Pod Autoscaler (HPA) and Vertical Pod Autoscaler (VPA). Because of this, the values may not match those from standard OS tools like `top`, as the metrics are designed to provide a stable signal for autoscalers rather than for pinpoint accuracy.

References and useful reading:

- `kubectl top` docs.
  [https://kubernetes.io/docs/reference/kubectl/generated/kubectl_top/](https://kubernetes.io/docs/reference/kubectl/generated/kubectl_top/)
- Kubernetes resource metrics pipeline.
  [https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-metrics-pipeline/](https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-metrics-pipeline/)
- `free` man page.
  [https://man7.org/linux/man-pages/man1/free.1.html](https://man7.org/linux/man-pages/man1/free.1.html)
- `top` man page.
  [https://man7.org/linux/man-pages/man1/top.1.html](https://man7.org/linux/man-pages/man1/top.1.html)

---

## Problem statement

Operators often observe three conflicting views of node resource usage:

1. `kubectl top node` (metrics.k8s.io via metrics-server)
2. `free` / `top` (reads `/proc/meminfo`, OS view)
3. Instrumentation from cAdvisor or Prometheus (cgroup-level metrics)

These differences matter because teams use `kubectl top` to reason about autoscaling and `free`/`top` to reason about capacity and troubleshooting. Understanding why they differ clarifies which tool to use when and how to troubleshoot when autoscalers behave unexpectedly.

---

## Technical deep dive — how `kubectl top node` is produced

### From Terminal to `/sys/fs/cgroup` (high level)

![kubectl top node](./kubectl-top-node.png)

### kubectl (Terminal layer)

**Metrics API**:

- Group Name: `metrics.k8s.io`
- API Version: `v1beta1`

```console
kubectl top node
NAME                            CPU(cores)   CPU(%)   MEMORY(bytes)   MEMORY(%)
```

You can query the API directly:

```console
kubectl get --raw "/apis/metrics.k8s.io/v1beta1/nodes" | jq .
```

Which returns a `NodeMetricsList` structure like:

```json
{
  "kind": "NodeMetricsList",
  "apiVersion": "metrics.k8s.io/v1beta1",
  "metadata": {},
  "items": [
    {
      "metadata": {
        "name": ""
      },
      "timestamp": "",
      "window": "",
      "usage": {
        "cpu": "",
        "memory": ""
      }
    }
  ]
}
```

### metrics-server

`metrics-server` periodically (default: every 60s) scrapes kubelet endpoints `/metrics/resource` or `/stats/summary` to collect Prometheus-format metrics like `node_cpu_usage_seconds_total` and `node_memory_working_set_bytes`. It transforms those into the Kubernetes `NodeMetricsList` / `NodeMetrics` API objects that `kubectl top` consumes.

> Note: metrics-server intentionally omits many container/pod-level Prometheus metrics when producing the node-level `NodeMetricsList`.

Example: kubelet exposes resources at `/api/v1/nodes/<node-name>/proxy/metrics/resource`:

```console
$ kubectl get --raw "/api/v1/nodes/<node-name>/proxy/metrics/resource"
# HELP node_cpu_usage_seconds_total [STABLE] Cumulative cpu time consumed by the node in core-seconds
# TYPE node_cpu_usage_seconds_total counter
node_cpu_usage_seconds_total 0 0
# HELP node_memory_working_set_bytes [STABLE] Current working set of the node in bytes
# TYPE node_memory_working_set_bytes gauge
node_memory_working_set_bytes 0 0
# HELP node_swap_usage_bytes [ALPHA] Current swap usage of the node in bytes. Reported only on non-windows systems
# TYPE node_swap_usage_bytes gauge
node_swap_usage_bytes 0 0
```

`NodeMetrics` and `NodeMetricsList` types live in the Kubernetes metrics API staging packages; here are the relevant definitions:

[NodeMetricsList](https://github.com/kubernetes/kubernetes/blob/v1.34.2/staging/src/k8s.io/metrics/pkg/apis/metrics/v1beta1/types.go#L24-L45)

```go
// NodeMetrics sets resource usage metrics of a node.
type NodeMetrics struct {
	metav1.TypeMeta `json:",inline"`
	// Standard object's metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metav1.ObjectMeta `json:"metadata,omitempty" protobuf:"bytes,1,opt,name=metadata"`

	// The following fields define time interval from which metrics were
	// collected from the interval [Timestamp-Window, Timestamp].
	Timestamp metav1.Time     `json:"timestamp" protobuf:"bytes,2,opt,name=timestamp"`
	Window    metav1.Duration `json:"window" protobuf:"bytes,3,opt,name=window"`

	// The memory usage is the memory working set.
	Usage v1.ResourceList `json:"usage" protobuf:"bytes,4,rep,name=usage,casttype=k8s.io/api/core/v1.ResourceList,castkey=k8s.io/api/core/v1.ResourceName,castvalue=k8s.io/apimachinery/pkg/api/resource.Quantity"`
}
```

[NodeMetricsList](https://github.com/kubernetes/kubernetes/blob/v1.34.2/staging/src/k8s.io/metrics/pkg/apis/metrics/v1beta1/types.go#L47-L58)

```go
// NodeMetricsList is a list of NodeMetrics.
type NodeMetricsList struct {
	metav1.TypeMeta `json:",inline"`
	// Standard list metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	metav1.ListMeta `json:"metadata,omitempty" protobuf:"bytes,1,opt,name=metadata"`

	// List of node metrics.
	Items []NodeMetrics `json:"items" protobuf:"bytes,2,rep,name:items"`
}
```

[v1.ResourceList](https://github.com/kubernetes/kubernetes/blob/v1.34.2/staging/src/k8s.io/api/core/v1/types.go#L6884-L6885)

```go
// ResourceList is a set of (resource name, quantity) pairs.
type ResourceList map[ResourceName]resource.Quantity
```

### kubelet — the call chain

At kubelet level, node resource metrics are collected via a chain of calls that ultimately read cgroup stats through cAdvisor:

```go
/*
 * +-------------------------------------------------------------------------------+
 * |Prometheus Metrics (node_cpu_usage_seconds_total/node_memory_working_set_bytes)|
 * +--------------------------+----------------------------------------------------+
 *                            |
 *       +--------------------v------------------+
 *       |ResourceAnalyzer.GetCPUAndMemoryStats()+------+Delegate
 *       +---------------------------------------+      |
 *                                   +------------------v-------------------+
 *                                   |SummaryProvider.GetCPUAndMemoryStats()|
 *                                   +------------------+-------------------+
 *                                                      |
 *                                    +-----------------v------------------+
 *                       Deletate+----+Kubelet.GetCgroupCPUAndMemoryStats()|
 *                               |    +------------------------------------+
 *          +--------------------v---------------------+
 *          |StatsProvider.GetCgroupCPUAndMemoryStats()|
 *          +--------------------+---------------------+
 *                               |
 *            +------------------v-----------------+
 *            |cadvisor.Interface.ContainerInfoV2()|
 *            +------------------------------------+
 */
```

`GetCgroupCPUAndMemoryStats` example:

```go
	rootStats, err := sp.provider.GetCgroupCPUAndMemoryStats("/", false)
	if err != nil {
		return nil, fmt.Errorf("failed to get root cgroup stats: %v", err)
	}
```

The call resolves to cAdvisor, which is responsible for reading cgroup accounting and returning container/cgroup metrics.

`ContainerInfoV2` is a thin wrapper that delegates to cAdvisor:

[https://github.com/kubernetes/kubernetes/blob/v1.34.2/pkg/kubelet/cadvisor/cadvisor_linux.go#L139-L141](https://github.com/kubernetes/kubernetes/blob/v1.34.2/pkg/kubelet/cadvisor/cadvisor_linux.go#L139-L141)

```go
// cadvisorClient is a wrapper around github.com/google/cadvisor/manager.Manager
func (cc *cadvisorClient) ContainerInfoV2(name string, options cadvisorapiv2.RequestOptions) (map[string]cadvisorapiv2.ContainerInfo, error) {
	return cc.GetContainerInfoV2(name, options)
}
```

### cAdvisor

Kubelet instantiates cAdvisor with platform-specific options (the snippet below is from kubelet startup logic):

[https://github.com/kubernetes/kubernetes/blob/v1.34.2/cmd/kubelet/app/server.go#L768-L774](https://github.com/kubernetes/kubernetes/blob/v1.34.2/cmd/kubelet/app/server.go#L768-L774)

_cmd/kubelet/app/server.go_

```go
	if kubeDeps.CAdvisorInterface == nil {
		imageFsInfoProvider := cadvisor.NewImageFsInfoProvider(s.ContainerRuntimeEndpoint)
		kubeDeps.CAdvisorInterface, err = cadvisor.New(imageFsInfoProvider, s.RootDirectory, cgroupRoots, cadvisor.UsingLegacyCadvisorStats(s.ContainerRuntimeEndpoint), s.LocalStorageCapacityIsolation)
		if err != nil {
			return err
		}
	}
```

#### Dynamic Housekeeping

> Dynamic Housekeeping dynamically adjusts the frequency of getting cgroup stats.

##### Configuration (Hardcoded in kubelet)

- Default Interval: 10s
- Max Interval: 15s

[https://github.com/kubernetes/kubernetes/blob/v1.34.2/pkg/kubelet/cadvisor/cadvisor_linux.go#L59-L60](https://github.com/kubernetes/kubernetes/blob/v1.34.2/pkg/kubelet/cadvisor/cadvisor_linux.go#L59-L60)

```go
const maxHousekeepingInterval = 15 * time.Second
const defaultHousekeepingInterval = 10 * time.Second
```

##### Mechanism

1.  Normal Operation: Runs every 10s to collect cgroup status
2.  Adaptive Throttling: If two consecutive cgroup statuses are identical, interval increases to 15s
3.  Jitter: Applied using formula `interval + interval * rand[0.0, 1.0)` to prevent periodic behavior

### `/sys/fs/cgroup` and working set calculation

Refer to the kernel cgroup v2 memory docs for background:
[https://docs.kernel.org/admin-guide/cgroup-v2.html#memory](https://docs.kernel.org/admin-guide/cgroup-v2.html#memory)

cAdvisor and kubelet compute memory working set from cgroup files. Two primary sources are:

- `/sys/fs/cgroup/<...>/memory.current` — total memory used by the cgroup and descendants.
- `/sys/fs/cgroup/<...>/memory.stat` — detailed fields such as `anon`, `file`, `inactive_file`.

cAdvisor's working set logic (from cAdvisor v0.53.0) uses either `memory.current - inactive_file` or `anon + file - inactive_file`, depending on availability:

[workingSet calculation in cAdvisor](https://github.com/google/cadvisor/blob/v0.53.0/container/libcontainer/handler.go#L845-L854)

Conceptually:

- `workingSet` = `memory.current` minus `inactive_file` (if present), but not less than zero.
- Or, when required fields are seen in memory.stat: `workingSet` = `anon + file - inactive_file`.

Reproducing the node working set / memory.working_set_bytes calculation using a shell script that mirrors kubelet behavior:

```sh
# This script reproduces what the kubelet does
# to calculate current working set of the node in bytes.
# node memory working set
anon_in_bytes=$(cat /sys/fs/cgroup/memory.stat | grep '^anon\b' | awk '{print $2}')
file_in_bytes=$(cat /sys/fs/cgroup/memory.stat | grep '^file\b' | awk '{print $2}')
memory_usage_in_bytes=$((anon_in_bytes + file_in_bytes))
memory_total_inactive_file=$(cat /sys/fs/cgroup/memory.stat | grep '^inactive_file\b' | awk '{print $2}')
memory_working_set=${memory_usage_in_bytes}
if [ "$memory_working_set" -lt "$memory_total_inactive_file" ]; then
    memory_working_set=0
else
    memory_working_set=$((memory_usage_in_bytes - memory_total_inactive_file))
fi
echo "memory.working_set_bytes $memory_working_set"
```

Quick reference for cgroup fields:

- **memory.current** — The total amount of memory currently being used by the cgroup and its descendants.
- **memory.stat** fields:
  - `anon` — anonymous mappings memory (brk/sbrk/mmap anonymous), e.g., heap.
  - `file` — filesystem cache usage (including tmpfs and shared memory).
  - `inactive_anon`, `active_anon`, `inactive_file`, `active_file`, `unevictable` — various page lists used by the kernel page reclaim algorithm.

---

## `free` / `top` — the OS perspective

`free` and `top` parse `/proc/meminfo` and present kernel-accounted memory statistics that include cached pages, buffers, slab, and other kernel structures. The relevant canonical documentation is the kernel’s procfs meminfo description:

[https://docs.kernel.org/filesystems/proc.html#The](https://docs.kernel.org/filesystems/proc.html#The) /proc Filesystem meminfo

And the `free/top` implementation (procps-ng) uses `meminfo` parsing; see the source for how `free` computes its values:

[https://gitlab.com/procps-ng/procps/-/blob/master/library/meminfo.c?ref_type=heads#L652-756](https://gitlab.com/procps-ng/procps/-/blob/master/library/meminfo.c?ref_type=heads#L652-756)

`free`’s view includes cached filesystem pages and other kernel-managed memory which is normally reclaimable — but the Kubernetes `working set` concept only subtracts the `inactive_file` portion, producing a smaller working set number that the autoscaler will use as a signal.

---

## Practical implications — which tool to trust?

- **For autoscaler decisions (HPA / VPA):** trust the Kubernetes metrics pipeline (`kubectl top`, metrics.k8s.io). Those metrics reflect cgroup-level working set and are intentionally curated for autoscalers. They are the canonical input for Kubernetes autoscaling logic.
- **For OS-level capacity planning and troubleshooting:** use `free`, `top`, and `/proc/meminfo`. Those tools show kernel caches and other memory that affect observed free memory on the node.
- **For container-level visibility:** use cAdvisor / kubelet `/metrics` or Prometheus with node-exporter and cAdvisor metrics for fine-grained metrics. Remember cAdvisor aggregates per-cgroup and can produce the **working set** concept used by kubelet.

---

## Troubleshooting guidance (actionable)

1. **If `kubectl top` shows much less memory used than `free`:**
   - Confirm which cgroup you inspected. `kubectl top` reports working set for the node cgroup (kubepods or root depending on environment).
   - Inspect `/sys/fs/cgroup/*/memory.stat` and `memory.current` to verify `inactive_file` and `anon` values.
   - Use `kubectl get --raw "/api/v1/nodes/<node>/proxy/metrics/resource"` to see kubelet-exposed metrics that metrics-server ingests.

2. **If autoscaler is not scaling but node looks full in `free`:**
   - Remember autoscaler uses metrics.k8s.io. Check metrics-server health and scrape intervals.
   - Ensure metrics-server has sufficient RBAC and kubelet permissions to read `/metrics/resource` or `/stats/summary`.
   - Confirm cAdvisor is reporting expected values; check kubelet logs for cAdvisor-related errors.

3. **If kubelet/cAdvisor metrics differ from Prometheus node-exporter:**
   - Node-exporter reads `/proc` and kernel counters; cAdvisor reads cgroup accounting. These are different sources (cgroup vs proc) — this is the **cgroup vs proc** split.
   - For containerized workloads, prefer cgroup-derived metrics when reasoning about container resource usage.

4. **Practical commands to inspect sources (examples):**
   - `kubectl get --raw "/apis/metrics.k8s.io/v1beta1/nodes" | jq .` — metrics-server output
   - `kubectl get --raw "/api/v1/nodes/<node>/proxy/metrics/resource"` — kubelet resource metrics
   - `cat /sys/fs/cgroup/<...>/memory.stat` and `cat /sys/fs/cgroup/<...>/memory.current` — cgroup data
   - `cat /proc/meminfo` — kernel global memory accounting (`free`/`top` input)

---

## Recommendations

- Use the right tool for the right job:
  - **Autoscaling & Kubernetes logic:** depend on `kubectl top` / metrics-server (`metrics.k8s.io`) and ensure metrics-server is healthy. These are the canonical inputs to autoscalers.
  - **Node capacity and debugging:** use `free`/`top` and `/proc/meminfo`, and interpret `cached`/`buffers` correctly.
  - **Container-level resource tuning:** use cAdvisor / kubelet `/stats/summary` or Prometheus cAdvisor metrics.

- If you need a single truth for both capacity planning and autoscaling experiments:
  - Record both `free`/`top` and `kubectl top` values and map them over time. That helps you build operational heuristics (e.g., "when `free` drops below X but `kubectl top` remains below Y, investigate kernel cache pressure").

- Consider export and correlation:
  - Export metrics-server or cAdvisor metrics into a time-series store (Prometheus) and correlate `memory_working_set` with `/proc/meminfo` fields to build a conversion model specific to your workloads and kernel version.

---

## Conclusion

`kubectl top node` and `free`/`top` answer different questions. `kubectl top` is tuned for Kubernetes autoscalers and reflects cgroup-derived working set semantics; `free`/`top` reflect kernel global accounting and include cache/buffers that the kernel can reclaim. Both views are valid — the key is to understand the pipeline (cAdvisor → kubelet → metrics-server → metrics.k8s.io → kubectl) and the underlying data sources (`/sys/fs/cgroup` vs `/proc`). When you know which signal is for autoscaling and which is for capacity troubleshooting, you can make correct operational decisions and avoid false positives during incidents.

---

## Appendix — original references & sources

- kubectl top docs: [https://kubernetes.io/docs/reference/kubectl/generated/kubectl_top/](https://kubernetes.io/docs/reference/kubectl/generated/kubectl_top/)
- Resource metrics pipeline: [https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-metrics-pipeline/](https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-metrics-pipeline/)
- `/sys/fs/cgroup` memory docs: [https://docs.kernel.org/admin-guide/cgroup-v2.html#memory](https://docs.kernel.org/admin-guide/cgroup-v2.html#memory)
- cAdvisor working set logic: [https://github.com/google/cadvisor/blob/v0.53.0/container/libcontainer/handler.go#L845-L854](https://github.com/google/cadvisor/blob/v0.53.0/container/libcontainer/handler.go#L845-L854)
- Kubernetes types & kubelet/cadvisor integration points (v1.34.2): referenced inline above.
