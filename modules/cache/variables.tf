variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subredes privadas del subnet group de Redis."
}

variable "allowed_security_group_ids" {
  type        = list(string)
  description = "Security groups que pueden conectarse al puerto 6379."
}

variable "node_type" {
  type = string
}

variable "engine_version" {
  type = string
}
