---
title: Access Services Running on Clusters
source: https://kubernetes.io/docs/tasks/access-application-cluster/access-cluster-services/#manually-constructing-apiserver-proxy-urls
author:
published:
created: 2026-05-10
description:
tags:
  - clippings
---

As mentioned above, you use the `kubectl cluster-info` command to retrieve the service's proxy URL. To create
proxy URLs that include service endpoints, suffixes, and parameters, you append to the service's proxy URL:
`http://`_`kubernetes_master_address`_`/api/v1/namespaces/`_`namespace_name`_`/services/`_`[https:]service_name[:port_name]`_`/proxy`

If you haven't specified a name for your port, you don't have to specify _port_name_ in the URL. You can also
use the port number in place of the _port_name_ for both named and unnamed ports.

By default, the API server proxies to your service using HTTP. To use HTTPS, prefix the service name with `https:`:
`http://<kubernetes_master_address>/api/v1/namespaces/<namespace_name>/services/<service_name>/proxy`

The supported formats for the `<service_name>` segment of the URL are:

- `<service_name>` - proxies to the default or unnamed port using http
- `<service_name>:<port_name>` - proxies to the specified port name or port number using http
- `https:<service_name>:` - proxies to the default or unnamed port using https (note the trailing colon)
- `https:<service_name>:<port_name>` - proxies to the specified port name or port number using https

##### Examples

- To access the Elasticsearch service endpoint `_search?q=user:kimchy`, you would use:

  ```
  http://192.0.2.1/api/v1/namespaces/kube-system/services/elasticsearch-logging/proxy/_search?q=user:kimchy
  ```

- To access the Elasticsearch cluster health information `_cluster/health?pretty=true`, you would use:

  ```
  https://192.0.2.1/api/v1/namespaces/kube-system/services/elasticsearch-logging/proxy/_cluster/health?pretty=true
  ```

  The health information is similar to this:

  ```json
  {
    "cluster_name": "kubernetes_logging",
    "status": "yellow",
    "timed_out": false,
    "number_of_nodes": 1,
    "number_of_data_nodes": 1,
    "active_primary_shards": 5,
    "active_shards": 5,
    "relocating_shards": 0,
    "initializing_shards": 0,
    "unassigned_shards": 5
  }
  ```

- To access the _https_ Elasticsearch service health information `_cluster/health?pretty=true`, you would use:

  ```
  https://192.0.2.1/api/v1/namespaces/kube-system/services/https:elasticsearch-logging:/proxy/_cluster/health?pretty=true
  ```
