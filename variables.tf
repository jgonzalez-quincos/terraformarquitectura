variable "vpc_cidr" {type = string }
variable "pub_subnets" { type = list (string)}
variable "priv_subnets" { type = list(string)}
##variable "vpc_id" {type = string}


variable "aws_region" {
    default = "us-east-1"
}

variable "aws_profile" {
    default = "seminario2"
}

/*
variable "vpc_cidr" {
    default = "192.168.1.0/24"
}*/