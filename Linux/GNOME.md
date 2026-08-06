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

## GNOME Shell extensions[^1]

```bash
yshngg@forge ~> gnome-extensions list
user-theme@gnome-shell-extensions.gcampax.github.com
appindicatorsupport@rgcjonas.gmail.com
system-monitor@gnome-shell-extensions.gcampax.github.com
clipboard-indicator@tudmotu.com
compiz-windows-effect@hermes83.github.com
desktop-cube@schneegans.github.com
just-perfection-desktop@just-perfection
dash-to-dock@micxgx.gmail.com
compiz-alike-magic-lamp-effect@hermes83.github.com
CoverflowAltTab@palatis.blogspot.com
gtk4-ding@smedius.gitlab.com
caffeine@patapon.info
tilingshell@ferrarodomenico.com
weatherornot@somepaulo.github.io
impatience@gfxmonk.net
flypie@schneegans.github.com
unite@hardpixel.eu
kando-integration@kando-menu.github.io
Vitals@CoreCoding.com
vertical-workspaces@G-dH.github.com
auto-move-windows@gnome-shell-extensions.gcampax.github.com
burn-my-windows@schneegans.github.com
blur-my-shell@aunetx
kimpanel@kde.org
apps-menu@gnome-shell-extensions.gcampax.github.com
background-logo@fedorahosted.org
launch-new-instance@gnome-shell-extensions.gcampax.github.com
places-menu@gnome-shell-extensions.gcampax.github.com
window-list@gnome-shell-extensions.gcampax.github.com
```


[^1]: https://extensions.gnome.org/