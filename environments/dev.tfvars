# El workspace de Terraform debe llamarse igual que este archivo: dev
#   terraform workspace new dev
#   terraform workspace select dev

aws_region  = "us-east-1"
aws_profile = "PSeminario"

# IP publica desde la que entras por SSH y a la API de k3s.
# Consultala con: curl -4 ifconfig.me
admin_cidr = "200.122.208.2/32"

# Quien puede abrir n8n en el puerto 30678.
# Dejala igual a admin_cidr, o pon "0.0.0.0/0" si debe verse desde cualquier red.
nodeport_cidr = "200.122.208.2/32"

# Red /23 partida en cuatro /26: dos publicas y dos privadas.
vpc_cidr           = "172.20.0.0/23"
pub_subnets        = ["172.20.0.0/26", "172.20.0.64/26"]
priv_subnets       = ["172.20.0.128/26", "172.20.0.192/26"]
availability_zones = ["us-east-1a", "us-east-1d"]

# Key pair que ya existe en EC2 (us-east-1). El .pem solo se usa en los outputs.
key_name     = "kp-lab-ps"
ssh_key_path = "/Users/juanpablolasprillacorrea/Downloads/kp-lab-ps.pem"

# Master: control plane de k3s. Worker: pods de n8n.
master_type      = "t3.medium"
worker_type      = "t3.large"
worker_count     = 1
root_volume_size = 30

# Elastic File System
efs_performance_mode = "generalPurpose"
efs_throughput_mode  = "bursting"

# RDS PostgreSQL
db_instance_class    = "db.t3.micro"
db_engine_version    = "16.8"
db_parameter_family  = "postgres16"
db_name              = "n8n"
db_username          = "n8n"
db_allocated_storage = 20

# ElastiCache Redis
redis_node_type      = "cache.t3.micro"
redis_engine_version = "7.1"
