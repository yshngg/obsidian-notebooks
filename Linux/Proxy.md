
```
$ cat /etc/profile.d/proxy.sh
export http_proxy=socks://127.0.0.1:1080
export https_proxy=socks://127.0.0.1:1080
export no_proxy="127.0.0.1,localhost,::1"

export HTTP_PROXY=socks://127.0.0.1:1080
export HTTPS_PROXY=socks://127.0.0.1:1080
export NO_PROXY="127.0.0.1,localhost,::1"
```

