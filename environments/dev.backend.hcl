# Backend remoto del workspace "dev".
# El bucket tiene que existir antes de terraform init. Este proyecto no lo crea.
# Cambia bucket y profile por los de tu cuenta.
bucket       = "REEMPLAZA-CON-TU-BUCKET"
key          = "n8n/terraform.tfstate"
region       = "us-east-1"
profile      = "PSeminario"
encrypt      = true
use_lockfile = true
