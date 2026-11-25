#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

WORKSPACE="$(terraform workspace show)"
VAR_FILE="environments/${WORKSPACE}.tfvars"

if [[ "$WORKSPACE" == "default" ]]; then
  echo "El workspace activo es default. Crea el del ambiente: terraform workspace new dev"
  exit 1
fi

if [[ ! -f "$VAR_FILE" ]]; then
  echo "No existe ${VAR_FILE} para el workspace ${WORKSPACE}."
  exit 1
fi

echo "Workspace: ${WORKSPACE}"
echo "Variables: ${VAR_FILE}"
terraform plan -var-file="$VAR_FILE"
