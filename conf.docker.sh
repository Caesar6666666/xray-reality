#!/bin/bash
json=$(curl -s https://raw.githubusercontent.com/Caesar6666666/xray-reality/blob/master/config.json)

keys=$(xray x25519)
pk=$(echo "$keys" | awk '/Private key:/ {print $3}')
pub=$(echo "$keys" | awk '/Public key:/ {print $3}')
serverIp=$(dig thelsy.top AAAA +short)
uuid=$(xray uuid)
shortId=$(openssl rand -hex 8)
url="vless://$uuid@$serverIp:443?path=%2F&security=reality&encryption=none&pbk=$pub&fp=chrome&type=http&sni=https://mirrors.tuna.tsinghua.edu.cn&sid=$shortId#IRVLESS-REALITY-04"

newJson=$(echo "$json" | jq \
    --arg pk "$pk" \
    --arg uuid "$uuid" \
    '.inbounds[0].streamSettings.realitySettings.privateKey = $pk | 
     .inbounds[0].settings.clients[0].id = $uuid |
     .inbounds[0].streamSettings.realitySettings.shortIds += ["'$shortId'"]')
echo "$newJson" | sudo tee /usr/local/etc/xray/config.json >/dev/null

sudo service xray restart


echo "$url" >> /root/test.url

exit 0
