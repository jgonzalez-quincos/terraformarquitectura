variable "public_subnet_id" {
  type        = string
  description = "Subred publica del master. Necesita IP publica para SSH y para publicar n8n."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Subredes privadas de los workers."
}

variable "master_sg_id" {
  type = string
}

variable "worker_sg_id" {
  type = string
}

variable "key_name" {
  type        = string
  description = "Key pair existente en EC2."
}

variable "master_type" {
  type = string
}

variable "worker_type" {
  type = string
}

variable "worker_count" {
  type = number
}

variable "root_volume_size" {
  type = number
}
