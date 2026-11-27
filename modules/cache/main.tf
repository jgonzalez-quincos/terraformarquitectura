resource "random_password" "auth" {
  length           = 32
  special          = true
  override_special = "!#%^*-_+="
}

resource "aws_security_group" "redis" {
  name_prefix = "sec-redis-${terraform.workspace}-"
  description = "Redis de n8n"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG-Redis-${terraform.workspace}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "redis" {
  count = length(var.allowed_security_group_ids)

  description              = "Redis desde los workers"
  type                     = "ingress"
  security_group_id        = aws_security_group.redis.id
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = var.allowed_security_group_ids[count.index]
}

resource "aws_elasticache_subnet_group" "this" {
  name        = "n8n-${terraform.workspace}"
  description = "Subredes privadas de Redis"
  subnet_ids  = var.subnet_ids

  tags = {
    Name = "Redis-Subnets-${terraform.workspace}"
  }
}

resource "aws_elasticache_replication_group" "this" {
  replication_group_id = "n8n-${terraform.workspace}"
  description          = "Redis para la cola de n8n"
  engine               = "redis"
  engine_version       = var.engine_version
  node_type            = var.node_type
  num_cache_clusters   = 1
  port                 = 6379
  parameter_group_name = "default.redis7"

  subnet_group_name  = aws_elasticache_subnet_group.this.name
  security_group_ids = [aws_security_group.redis.id]

  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  auth_token                 = random_password.auth.result
  automatic_failover_enabled = false
  snapshot_retention_limit   = 0
  apply_immediately          = true

  tags = {
    Name = "Redis-${terraform.workspace}"
  }
}
