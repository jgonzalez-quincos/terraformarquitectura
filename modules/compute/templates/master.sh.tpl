#!/bin/bash
set -euxo pipefail
exec > /var/log/user-data.log 2>&1

dnf install -y nfs-utils

IMDS_TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
PRIVATE_IP=$(curl -s -H "X-aws-ec2-metadata-token: $IMDS_TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)
PUBLIC_IP=$(curl -s -H "X-aws-ec2-metadata-token: $IMDS_TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4)

curl -sfL https://get.k3s.io | \
  K3S_TOKEN="${k3s_token}" \
  INSTALL_K3S_EXEC="server --tls-san $${PUBLIC_IP} --node-ip $${PRIVATE_IP} --write-kubeconfig-mode 644 --disable=traefik --node-taint node-role.kubernetes.io/control-plane=true:NoSchedule" \
  sh -
