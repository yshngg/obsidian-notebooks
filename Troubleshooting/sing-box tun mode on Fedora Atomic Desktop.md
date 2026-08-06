```bash
yshngg@forge ~> sudo sing-box run -c ./config.json
```


```json
yshngg@forge ~> cat ./config.json
{
  "log": {
    "level": "debug",
    "timestamp": true
  },
  "dns": {
    "servers": [
      {
        "tag": "dns_tls",
        "type": "tls",
        "server": "1.1.1.1",
      },
      {
        "tag": "dns_direct",
        "type": "tls",
        "server": "223.5.5.5"
      }
    ],
    "strategy": "ipv4_only"
  },
  "inbounds": [
    {
      "type": "tun",
      "tag": "tun-in",
      "interface_name": "singbox-tun",
      "address": ["172.19.0.1/30"],
      "auto_route": true,
      "auto_redirect": true,
      "strict_route": true
    }
  ],
  "outbounds": [
    {
      "type": "direct",
      "tag": "direct"
    }
}
```