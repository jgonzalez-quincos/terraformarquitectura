variable "aws_region" {
  type        = string
  description = "Region de AWS."
  default     = "us-east-1"
}

variable "aws_profile" {
  type        = string
  description = "Perfil de AWS CLI. Debe ser el mismo de environments/<workspace>.backend.hcl."
}

variable "admin_cidr" {
  type        = string
  description = "CIDR desde el que se permite SSH y la API de Kubernetes. Ejemplo: 200.122.208.2/32."
}

variable "nodeport_cidr" {
  type        = string
  description = "CIDR que puede abrir n8n en el puerto 30678. Puede ser la IP de administracion o 0.0.0.0/0."
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR de la VPC."
}

variable "pub_subnets" {
  type        = list(string)
  description = "CIDRs de las subredes publicas. Una por zona de disponibilidad."
}

variable "priv_subnets" {
  type        = list(string)
  description = "CIDRs de las subredes privadas. Una por zona de disponibilidad."
}

variable "availability_zones" {
  type        = list(string)
  description = "Zonas de disponibilidad, en el mismo orden que las subredes."
  default     = ["us-east-1a", "us-east-1d"]
}

variable "key_name" {
  type        = string
  description = "Nombre de un key pair que ya exista en EC2. Este codigo no lo crea."
}

variable "ssh_key_path" {
  type        = string
  description = "Ruta local del .pem. Solo se usa para armar el comando SSH de las salidas."
}

variable "master_type" {
  type        = string
  description = "Tipo de instancia del master de k3s. No corre cargas de n8n."
  default     = "t3.medium"
}

variable "worker_type" {
  type        = string
  description = "Tipo de instancia de los workers. Ahi corren los pods de n8n."
  default     = "t3.large"
}

variable "worker_count" {
  type        = number
  description = "Cantidad de workers de EC2. El laboratorio usa 1."
  default     = 1
}

variable "root_volume_size" {
  type        = number
  description = "Tamano en GiB del disco raiz de master y workers."
  default     = 30
}

variable "efs_performance_mode" {
  type        = string
  description = "Modo de rendimiento de EFS: generalPurpose o maxIO."
  default     = "generalPurpose"
}

variable "efs_throughput_mode" {
  type        = string
  description = "Modo de throughput de EFS: bursting, provisioned o elastic."
  default     = "bursting"
}

variable "db_instance_class" {
  type        = string
  description = "Clase de la instancia RDS PostgreSQL."
  default     = "db.t3.micro"
}

variable "db_engine_version" {
  type        = string
  description = "Version de PostgreSQL."
  default     = "16.8"
}

variable "db_parameter_family" {
  type        = string
  description = "Familia del parameter group. Debe coincidir con la version mayor."
  default     = "postgres16"
}

variable "db_name" {
  type        = string
  description = "Nombre de la base de datos de n8n."
  default     = "n8n"
}

variable "db_username" {
  type        = string
  description = "Usuario maestro de RDS. La contrasena la genera Terraform."
  default     = "n8n"
}

variable "db_allocated_storage" {
  type        = number
  description = "Almacenamiento inicial de RDS en GiB."
  default     = 20
}

variable "redis_node_type" {
  type        = string
  description = "Tipo de nodo de ElastiCache Redis."
  default     = "cache.t3.micro"
}

variable "redis_engine_version" {
  type        = string
  description = "Version de Redis."
  default     = "7.1"
}
