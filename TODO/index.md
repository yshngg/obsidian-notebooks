Why `dd if=/dev/zero of=/dev/shm/mem bs=1M count=16` doesn't consume memory resource, but `dd if=/dev/zero of=/tmp/cache.dat bs=1M count=16` do.

---

https://github.com/NoSkillGirl/kyverno/blob/c4ee793c2cda8fc226e6135921fff8e7e6507136/pkg/dclient/client.go#L312-L320
https://github.com/kyverno/kyverno/issues/2126

https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#equality-based-requirement
The latter selects all resources with key equal to tier and value distinct from frontend, and all resources with no labels with the tier key.
