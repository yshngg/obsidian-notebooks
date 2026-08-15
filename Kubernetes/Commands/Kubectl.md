## construct apiserver proxy URLs

```bash
kubectl get --raw "/api/v1/nodes/$NODE/proxy/<path>"
kubectl get --raw "/api/v1/namespaces/$NAMESPACE/services/$SERVICE/proxy/<path>"
kubectl get --raw "/api/v1/namespaces/$NAMESPACE/pods/$POD/proxy/<path>"
```

## List all resources

```bash
kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --ignore-not-found -n $NAMESPACE
```

## kubectl debug

```bash
kubectl debug -n <namespace> <pod> -it --image=busybox:latest -- sh
```

## kubectl top pods filtered by node

```bash
kubectl get pods --all-namespaces --no-headers --field-selector spec.nodeName=$node | cut -f 1,2 -w | xargs -L 1 --max-procs 0 --verbose kubectl top pods --no-headers -n

# kubectl top pods filter by the node
# https://github.com/kubernetes/kubernetes/issues/131896
kubectl get pods --field-selector spec.nodeName='<name>' -A -o custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name --no-headers | \
    xargs -I {} sh -c "kubectl top pod --no-headers -n {}" | \
    column -t
```

## kubectl-ai

```bash
# deepseek https://api-docs.deepseek.com/

export OPENAI_API_KEY=<key>
export OPENAI_ENDPOINT=https://api.deepseek.com/v1
kubectl-ai --llm-provider=openai --model=deepseek-chat # or deepseek-reasoner
```
