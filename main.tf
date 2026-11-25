module "network" {
  source = "./modules/network"

  vpc_cidr           = var.vpc_cidr
  pub_subnets        = var.pub_subnets
  priv_subnets       = var.priv_subnets
  availability_zones = var.availability_zones
}

module "security" {
  source = "./modules/security"

  vpc_id        = module.network.vpc_id
  admin_cidr    = var.admin_cidr
  nodeport_cidr = var.nodeport_cidr
}

module "storage" {
  source = "./modules/storage"

  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.private_subnets
  allowed_security_group_ids = [
    module.security.master_sg_id,
    module.security.worker_sg_id,
  ]
  performance_mode = var.efs_performance_mode
  throughput_mode  = var.efs_throughput_mode
}

module "database" {
  source = "./modules/database"

  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.private_subnets
  allowed_security_group_ids = [
    module.security.master_sg_id,
    module.security.worker_sg_id,
  ]
  instance_class    = var.db_instance_class
  engine_version    = var.db_engine_version
  parameter_family  = var.db_parameter_family
  db_name           = var.db_name
  username          = var.db_username
  allocated_storage = var.db_allocated_storage
}

module "cache" {
  source = "./modules/cache"

  vpc_id                     = module.network.vpc_id
  subnet_ids                 = module.network.private_subnets
  allowed_security_group_ids = [module.security.worker_sg_id]
  node_type                  = var.redis_node_type
  engine_version             = var.redis_engine_version
}

module "compute" {
  source = "./modules/compute"

  public_subnet_id   = module.network.public_subnets[0]
  private_subnet_ids = module.network.private_subnets
  master_sg_id       = module.security.master_sg_id
  worker_sg_id       = module.security.worker_sg_id
  key_name           = var.key_name
  master_type        = var.master_type
  worker_type        = var.worker_type
  worker_count       = var.worker_count
  root_volume_size   = var.root_volume_size
}

resource "random_password" "n8n_encryption_key" {
  length  = 32
  special = false
}
