## adb

**http proxy**

```bash
adb shell settings put global http_proxy "192.168.0.108:1080"
adb shell settings delete global http_proxy
```

Ref: https://github.com/waydroid/waydroid/issues/870

## curl

```bash
curl -fsSL ifconfig.me
curl -fsSL ipinfo.io/ip

curl -x http://127.0.0.1:1080 -fsSL ipinfo.io/ip

curl -x https://127.0.0.1:1080 --proxy-cacert ./pki/ca.pem -v --proxy-http2 -I https://example.org

# download a file
curl -O https://example.com/filename
```

## dd

```bash
dd if=/dev/zero of=/dev/null

dd if=/dev/zero of=/dev/shm/mem bs=1M count=16

dd if=/dev/zero of=/tmp/cache.dat bs=1M count=16
```

## docker

#### How to install docker-compose on Fedora CoreOS?

```bash
# Just install it using `rpm-ostree`
sudo rpm-ostree install docker-compose

# and then reboot in order for the changes to the OSTree to take effect
sudo systemctl reboot
```

xref: https://techoverflow.net/2021/05/15/how-to-install-docker-compose-on-fedora-coreos/

## firewalld

https://firewalld.org/documentation/howto/open-a-port-or-service.html

## fish

```fish
function fish_user_key_bindings
    # Execute this once per mode that emacs bindings should be used in
    fish_default_key_bindings -M insert

    # Then execute the vi-bindings so they take precedence when there's a conflict.
    # Without --no-erase fish_vi_key_bindings will default to
    # resetting all bindings.
    # The argument specifies the initial mode (insert, "default" or visual).
    fish_vi_key_bindings --no-erase insert
end
```

## flatpak

```bash
flatpak override --user --filesystem=xdg-config/gtk-4.0:ro
```

## fzf

```bash
# open in tmux popup if on tmux, otherwise use --height mode

# ~/.bashrc
export FZF_DEFAULT_OPTS='--height 40% --tmux bottom,40% --layout reverse --border top'

# ~/.config/fish/config.fish
set -gx FZF_DEFAULT_OPTS '--height 40% --tmux bottom,40% --layout reverse --border top'
```

## git

```bash
git config --local user.email yshngg@outlook.com
git config --local user.name 'Yusheng'

git config --local http.proxy <proxy>
git config --local https.proxy <proxy>

git config --global http.proxy http://127.0.0.1:1080
git config --global https.proxy http://127.0.0.1:1080

man gitrevisions # specify revisions and ranges for Git
```

### Configuring default branch name

```bash
git config --global init.defaultBranch main
```

### Configuring line endings treatment

#### Linux/MacOS

```bash
git config --global core.autocrlf input
git config --global core.safecrlf warn
```

#### Windows

```bash
git config --global core.autocrlf true
git config --global core.safecrlf warn
```

## gsetting

```bash
gsettings set org.gnome.system.proxy mode 'manual'
gsettings set org.gnome.system.proxy.socks host 'proxy.local'
gsettings set org.gnome.system.proxy.socks port 1080
gsettings set org.gnome.system.proxy ignore-hosts '["localhost", "127.0.0.0/8", "::1"]'
```

## go

```bash
GODEBUG=http2debug=2,http2xconnect=1 go run .
```

## helm

```bash
helm upgrade --debug -n <namespace> --create-namespace -i <release> <chart>
```

## journalctl

```bash
journalctl -f -o cat -u systemd-logind.service
```

## install

```
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

## ip

https://www.cyberciti.biz/faq/linux-ip-command-examples-usage-syntax/

## hostname

```bash
# primary IP address of the local machine
hostname --all-ip-addresses | cut --delimiter ' ' --fields 1
```

### proxy

```bash
#!/usr/bin/env bash

# Set up HTTP proxy
eval mode=$(gsettings get org.gnome.system.proxy mode)
eval host=$(gsettings get org.gnome.system.proxy.https host)
eval port=$(gsettings get org.gnome.system.proxy.https port)
if [[ $mode == 'manual' && -n $host && $port -ne 0 ]]; then
  export HTTPS_PROXY="http://$host:$port"
fi
```

```bash
#!/usr/bin/env fish

eval set mode (gsettings get org.gnome.system.proxy mode)
eval set host (gsettings get org.gnome.system.proxy.https host)
eval set port (gsettings get org.gnome.system.proxy.https port)
if [ $mode = 'manual' ]; and [ -n $host ]; and [ $port -ne 0 ]
    set -gx HTTPS_PROXY "http://$host:$port"
end
```

## shell script

```bash
#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
```

## ss

```bash
ss -tmpie
```

## ssh

```bash
ssh -i ".pem" -L <port>:127.0.0.1:<port> -N root@<address>
```

## sudo

```bash
# when you forget to use sudo with a command
sudo !!
```

#### "Command Not Found" When Using Sudo

Example:

```bash
$ tun2proxy-bin --setup --proxy "socks5://192.168.0.108:1080"
[2026-03-15T12:07:52Z ERROR tun2proxy_bin] main loop error: Operation not permitted (os error 1)
[2026-03-15T12:07:52Z INFO  tun2proxy_bin] Runtime.block_on exiting...
[2026-03-15T12:07:52Z INFO  tun2proxy_bin] Starting 2s exit timer
Error: Os { code: 1, kind: PermissionDenied, message: "Operation not permitted" }

$ sudo tun2proxy-bin --setup --proxy "socks5://192.168.0.108:1080"
sudo: tun2proxy-bin: command not found
```

```bash
sudo -E env "PATH=$PATH" <command> [arguments]
```

xref: https://stackoverflow.com/a/29400598

## tcpdump

```bash
tcpdump -vv -X -i lo port 8088
```

## tmux

```bash
# Config tmux default shell
cat << EOF >> ~/.tmux.conf
set-option -g default-shell /usr/bin/fish

EOF
```

## vim

xref: https://stackoverflow.com/a/7078429

```vim
" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %
```

[50+ Essential Linux Commands: A Comprehensive Guide](https://www.digitalocean.com/community/tutorials/linux-commands)
