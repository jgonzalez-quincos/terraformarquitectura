variable "vpc_id" {
  type        = string
  description = "VPC donde se crean los security groups de las instancias."
}

variable "admin_cidr" {
  type        = string
  description = "CIDR de administracion para SSH y la API de Kubernetes."
}

variable "nodeport_cidr" {
  type        = string
  description = "CIDR que puede llegar al NodePort 30678 de n8n."
}
