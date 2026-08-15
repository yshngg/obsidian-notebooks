```bash
$ mkdir -p /etc/systemd/system/rpm-ostreed.service.d
$ cat > /etc/systemd/system/rpm-ostreed.service.d/http-proxy.conf << EOF
[Service]
Environment="http_proxy=http://127.0.0.1:1080"
EOF
$ systemctl daemon-reload
$ systemctl restart rpm-ostreed.service
```

```bash
systemctl edit rpm-ostreed.service
```

https://github.com/coreos/rpm-ostree/issues/762#issuecomment-434256478
https://github.com/coreos/rpm-ostree/issues/208#issuecomment-307369036
