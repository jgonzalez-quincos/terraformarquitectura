#!/bin/bash
set -euxo pipefail
exec > /var/log/user-data.log 2>&1

dnf install -y nfs-utils

IMDS_TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
PRIVATE_IP=$(curl -s -H "X-aws-ec2-metadata-token: $IMDS_TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)

for attempt in $(seq 1 60); do
  if curl -sk --max-time 5 "https://${master_private_ip}:6443/ping" | grep -q pong; then
    break
  fi
  echo "esperando al master, intento $${attempt}"
  sleep 10
done

curl -sfL https://get.k3s.io | \
  K3S_URL="https://${master_private_ip}:6443" \
  K3S_TOKEN="${k3s_token}" \
  INSTALL_K3S_EXEC="agent --node-ip $${PRIVATE_IP}" \
  sh -
