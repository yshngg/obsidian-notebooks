## Kubectl Plugin - `kubectl-rund`

**Run** your source code **d**irectly in Kubernetes cluster without building image.

- kubectl-go
- kubectl-python
- kubectl-uv
- kubectl-cargo

以 kubectl-go 为例  
从 go.mod 中读取 go 版本构造基础镜像  
在集群中运行基础镜像（通过 sleep 1h 保持容器运行），利用 kubectl cp 命令将源代码 copy 到容器中  
利用 kubectl exec 命令运行源码

Features:
1.  Run with detach mode
2.  Specify requests and limits of CPU or memory

[https://github.com/EdwardLab/initd](https://github.com/EdwardLab/initd)  
[https://github.com/golang/mod/blob/master/modfile/rule.go#L329](https://github.com/golang/mod/blob/master/modfile/rule.go#L329)

## Reference

https://github.com/kubernetes/sample-cli-plugin
https://kubernetes.io/docs/tasks/extend-kubectl/kubectl-plugins/

https://github.com/kubernetes/cli-runtime
https://github.com/kubernetes-sigs/krew/
