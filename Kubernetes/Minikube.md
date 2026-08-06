```
minikube start --driver=docker --nodes 3

minikube start --driver kvm2 --memory 6144 --network-plugin=cni --enable-default-cni --container-runtime=cri-o --bootstrapper=kubeadm

minikube addons enable metrics-server

helm install kube-prometheus-stack --namespace monitoring --create-namespace oci://ghcr.io/prometheus-community/charts/kube-prometheus-stack
```
