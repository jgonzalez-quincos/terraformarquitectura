#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if ! command -v helm >/dev/null 2>&1; then
  echo "Falta helm. En macOS: brew install helm"
  exit 1
fi

if ! command -v kubectl >/dev/null 2>&1; then
  echo "Falta kubectl. En macOS: brew install kubectl"
  exit 1
fi

WORKSPACE="$(terraform workspace show)"
KUBECONFIG_FILE="${ROOT}/kubeconfig-${WORKSPACE}"

if [[ ! -f "$KUBECONFIG_FILE" ]]; then
  echo "No esta ${KUBECONFIG_FILE}."
  echo "Generalo con el comando de la salida kubeconfig_command y vuelve a correr este script."
  exit 1
fi

export KUBECONFIG="$KUBECONFIG_FILE"

DB_PASSWORD="$(terraform output -raw db_password)"
REDIS_PASSWORD="$(terraform output -raw redis_password)"
ENCRYPTION_KEY="$(terraform output -raw n8n_encryption_key)"
DB_HOST="$(terraform output -raw db_address)"
DB_NAME="$(terraform output -raw db_name)"
DB_USER="$(terraform output -raw db_username)"
REDIS_HOST="$(terraform output -raw redis_address)"
EFS_DNS="$(terraform output -raw efs_dns_name)"
MASTER_IP="$(terraform output -raw master_public_ip)"

VALUES_FILE="$(mktemp)"
trap 'rm -f "$VALUES_FILE"' EXIT

cat > "$VALUES_FILE" <<EOF
publicHost: "${MASTER_IP}"
publicUrl: "http://${MASTER_IP}:30678"
database:
  host: "${DB_HOST}"
  name: "${DB_NAME}"
  user: "${DB_USER}"
redis:
  host: "${REDIS_HOST}"
  tls: true
efs:
  dnsName: "${EFS_DNS}"
secrets:
  dbPassword: "${DB_PASSWORD}"
  redisPassword: "${REDIS_PASSWORD}"
  encryptionKey: "${ENCRYPTION_KEY}"
EOF

kubectl get namespace n8n >/dev/null 2>&1 || kubectl create namespace n8n

helm upgrade --install n8n "${ROOT}/helm/n8n" \
  --namespace n8n \
  --create-namespace \
  --values "${ROOT}/helm/n8n/values.yaml" \
  --values "$VALUES_FILE"

echo "n8n disponible en http://${MASTER_IP}:30678"
