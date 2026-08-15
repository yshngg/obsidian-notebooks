## Install

```bash
rpm-ostree install fcitx5 fcitx5-autostart fcitx5-rime

systemctl reboot
```

## 雾凇拼音

```bash
rm -rf ~/.local/share/fcitx5/rime

git clone --depth 1 https://github.com/iDvel/rime-ice.git ~/.local/share/fcitx5/rime
```

Restart

## Reference

https://rime.im/
https://fcitx-im.org/wiki/Fcitx_5
https://github.com/fcitx/fcitx5
https://github.com/fcitx/fcitx5-rime
https://github.com/iDvel/rime-ice