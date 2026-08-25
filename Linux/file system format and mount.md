```bash
dd if=/dev/zero of=/apkcache.img bs=1M count=128
mkfs.ext2 -F /apkcache.img
mkdir -p /etc/apk/cache
mount -t ext2 /apkcache.img /etc/apk/cache
```
