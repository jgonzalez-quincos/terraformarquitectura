variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subredes privadas, una por zona, donde se crean los mount targets."
}

variable "allowed_security_group_ids" {
  type        = list(string)
  description = "Security groups de los nodos que montan EFS."
}

variable "performance_mode" {
  type = string
}

variable "throughput_mode" {
  type = string
}
