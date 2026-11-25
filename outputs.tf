output "master_public_ip" {
  description = "IP publica del master de k3s."
  value       = module.compute.master_public_ip
}

output "master_private_ip" {
  description = "IP privada del master."
  value       = module.compute.master_private_ip
}

output "worker_private_ips" {
  description = "IPs privadas de los workers."
  value       = module.compute.worker_private_ips
}

output "master_ssh_command" {
  description = "Conexion SSH al master. La ruta del .pem sale de ssh_key_path."
  value       = "ssh -i ${var.ssh_key_path} ec2-user@${module.compute.master_public_ip}"
}

output "kubeconfig_command" {
  description = "Descarga kubeconfig y reemplaza 127.0.0.1 por la IP publica del master."
  value       = "ssh -i ${var.ssh_key_path} ec2-user@${module.compute.master_public_ip} \"sudo cat /etc/rancher/k3s/k3s.yaml\" | sed \"s/127.0.0.1/${module.compute.master_public_ip}/\" > kubeconfig-${terraform.workspace}"
}

output "n8n_url" {
  description = "URL de n8n despues de ejecutar scripts/deploy-n8n.sh."
  value       = "http://${module.compute.master_public_ip}:30678"
}

output "efs_id" {
  description = "ID del sistema de archivos EFS."
  value       = module.storage.efs_id
}

output "efs_dns_name" {
  description = "DNS de EFS que usa el PersistentVolume de n8n."
  value       = module.storage.efs_dns_name
}

output "db_address" {
  description = "Endpoint de RDS PostgreSQL."
  value       = module.database.address
}

output "db_name" {
  description = "Nombre de la base."
  value       = module.database.db_name
}

output "db_username" {
  description = "Usuario de la base."
  value       = module.database.username
}

output "db_password" {
  description = "Contrasena generada de RDS. Queda en el state."
  value       = module.database.password
  sensitive   = true
}

output "redis_address" {
  description = "Endpoint primario de Redis."
  value       = module.cache.address
}

output "redis_port" {
  description = "Puerto de Redis."
  value       = module.cache.port
}

output "redis_password" {
  description = "Token de autenticacion de Redis. Queda en el state."
  value       = module.cache.auth_token
  sensitive   = true
}

output "n8n_encryption_key" {
  description = "Llave de cifrado de n8n. Queda en el state y no debe cambiar entre despliegues."
  value       = random_password.n8n_encryption_key.result
  sensitive   = true
}
