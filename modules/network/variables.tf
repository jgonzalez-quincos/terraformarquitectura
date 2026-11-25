variable "vpc_cidr" {
  description = "Rango CIDR para la VPC."
  type        = string
}

variable "pub_subnets" {
  description = "Lista de CIDRs para subredes publicas."
  type        = list(string)
}

variable "priv_subnets" {
  description = "Lista de CIDRs para subredes privadas."
  type        = list(string)
}

variable "availability_zones" {
  description = "Zonas de disponibilidad, en el mismo orden que las subredes."
  type        = list(string)
}
