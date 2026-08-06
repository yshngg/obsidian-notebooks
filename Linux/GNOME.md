https://www.gnome.org/

## gsettings

```bash
gsettings set org.gnome.system.proxy mode 'manual'
gsettings set org.gnome.system.proxy.socks host '127.0.0.1'
gsettings set org.gnome.system.proxy.socks port 1080
gsettings set org.gnome.system.proxy ignore-hosts '["localhost", "127.0.0.0/8", "::1"]'
```


## Mojave Gtk Theme

https://github.com/vinceliuice/Mojave-gtk-theme

```bash
./install.sh -c light -o solid -a standard -s standard -t blue -i gnome -l

# Mojave-Light-solid-blue and Mojave-Dark-solid-blue
./install.sh -c dark -o solid -a standard -s standard -t blue -i gnome -l
```

```bash
flatpak override --user --filesystem=xdg-config/gtk-4.0:ro
```
