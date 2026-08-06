Error: INSTALLATION FAILED: failed pre-install: resource Job/monitoring/kube-prometheus-stack-admission-create not ready. status: InProgress, message: Job in progress

```bash
yshngg@forge ~> kubectl logs -n monitoring jobs/kube-prometheus-stack-admission-create
W0712 05:03:35.263958       1 client_config.go:683] Neither --kubeconfig nor --master was specified.  Using the inClusterConfig.  This might not work.
Error: failed to get secret: error getting secret: Get "https://192.168.49.2:32443/api/v1/namespaces/monitoring/secrets/kube-prometheus-stack-admission": dial tcp 192.168.49.2:32443: connect: connection refused
Usage:
  kube-webhook-certgen create [flags]

Flags:
      --ca-name string       Name of ca file in the secret (default "ca")
      --cert-name string     Name of cert file in the secret (default "cert")
  -h, --help                 help for create
      --host string          Comma-separated hostnames and IPs to generate a certificate for
      --key-name string      Name of key file in the secret (default "key")
      --namespace string     Namespace of the secret where certificate information will be written
      --secret-name string   Name of the secret where certificate information will be written
      --secret-type string   Type of the secret where certificate information will be written (default "Opaque")

Global Flags:
      --kubeconfig string   Path to kubeconfig file: e.g. ~/.kube/kind-config-kind
      --log-format string   Log format: text|json (default "json")
      --log-level string    Log level: error|warn|info|debug (default "info")

{"time":"2026-07-12T05:03:35.264412858Z","level":"ERROR","source":{"function":"github.com/jkroepke/kube-webhook-certgen/cmd.Execute","file":"github.com/jkroepke/kube-webhook-certgen@v1.8.4/cmd/root.go","line":47},"msg":"failed to get secret: error getting secret: Get \"https://192.168.49.2:32443/api/v1/namespaces/monitoring/secrets/kube-prometheus-stack-admission\": dial tcp 192.168.49.2:32443: connect: connection refused"}
```

```bash
yshngg@forge ~> kubectl debug -n kube-system pods/metrics-server-9d74bb658-ph89m --image busybox -it -- env | grep -E 'KUBERNETES_SERVICE_HOST|KUBERNETES_SERVICE_PORT'
KUBERNETES_SERVICE_PORT=443
KUBERNETES_SERVICE_HOST=10.96.0.1
KUBERNETES_SERVICE_PORT_HTTPS=443
```

```bash
yshngg@forge ~/P/g/j/kube-webhook-certgen (main)> kubectl get pods/kube-apiserver-minikube -n kube-system -o wide
NAME                      READY   STATUS    RESTARTS      AGE   IP             NODE       NOMINATED NODE   READINESS GATES
kube-apiserver-minikube   1/1     Running   1 (80m ago)   93m   192.168.49.2   minikube   <none>           <none>
```

```bash
yshngg@forge ~/P/g/j/kube-webhook-certgen (main)> kubectl describe service/kubernetes
Name:                     kubernetes
Namespace:                default
Labels:                   component=apiserver
                          provider=kubernetes
Annotations:              <none>
Selector:                 <none>
Type:                     ClusterIP
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       10.96.0.1
IPs:                      10.96.0.1
Port:                     https  443/TCP
TargetPort:               8443/TCP
Endpoints:                192.168.49.2:8443
Session Affinity:         None
Internal Traffic Policy:  Cluster
Events:                   <none>
```
