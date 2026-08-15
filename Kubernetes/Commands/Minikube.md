```bash
minikube start --driver=docker --nodes 3

minikube start --driver kvm2 --memory 6144 --network-plugin=cni --enable-default-cni --container-runtime=cri-o --bootstrapper=kubeadm

minikube addons enable metrics-server

helm install kube-prometheus-stack --namespace monitoring --create-namespace oci://ghcr.io/prometheus-community/charts/kube-prometheus-stack
```

```bash
# cannot be local proxy, shch as 127.0.0.1 or localhost
# for workaround, please refer to:
# https://github.com/kubernetes/minikube/issues/13897#issuecomment-1166252008
export HTTP_PROXY=<proxy>
export HTTPS_PROXY=<proxy>

# More information, see:
# https://minikube.sigs.k8s.io/docs/handbook/vpn_and_proxy/
export NO_PROXY=localhost,127.0.0.1,10.96.0.0/12,192.168.59.0/24,192.168.49.0/24,192.168.39.0/24

sudo usermod -aG docker $USER && newgrp docker

minikube start --driver=docker --nodes 3
```

```bash
#!/usr/bin/env fish
set -gx HTTP_PROXY http://(hostname --all-ip-addresses | cut --delimiter ' ' --fields 1):1080
set -gx NO_PROXY localhost,127.0.0.1,10.96.0.0/12,192.168.59.0/24,192.168.49.0/24,192.168.39.0/24

#!/usr/bin/env bash
export HTTP_PROXY="http://$(hostname --all-ip-addresses | cut --delimiter ' ' --fields 1):1080"
export NO_PROXY=localhost,127.0.0.1,10.96.0.0/12,192.168.59.0/24,192.168.49.0/24,192.168.39.0/24
```
