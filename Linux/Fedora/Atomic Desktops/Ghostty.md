https://ghostty.org/docs/install/binary#atomic-desktops-(silverblue)

```bash
. /etc/os-release
curl -fsSL "https://copr.fedorainfracloud.org/coprs/scottames/ghostty/repo/fedora-${VERSION_ID}/scottames-ghostty-fedora-${VERSION_ID}.repo" | sudo tee /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:scottames:ghostty.repo > /dev/null
```

```bash
rpm-ostree refresh-md && \
rpm-ostree install ghostty
```
