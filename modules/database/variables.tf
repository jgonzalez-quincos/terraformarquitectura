variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subredes privadas del subnet group de RDS."
}

variable "allowed_security_group_ids" {
  type        = list(string)
  description = "Security groups que pueden conectarse al puerto 5432."
}

variable "instance_class" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "parameter_family" {
  type = string
}

variable "db_name" {
  type = string
}

variable "username" {
  type = string
}

variable "allocated_storage" {
  type = number
}
