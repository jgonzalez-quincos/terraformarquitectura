resource "random_password" "db" {
  length           = 24
  special          = true
  override_special = "!#%^*-_+="
}

resource "aws_security_group" "rds" {
  name_prefix = "sec-rds-${terraform.workspace}-"
  description = "PostgreSQL de n8n"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG-RDS-${terraform.workspace}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "postgres" {
  count = length(var.allowed_security_group_ids)

  description              = "PostgreSQL desde los nodos de k3s"
  type                     = "ingress"
  security_group_id        = aws_security_group.rds.id
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = var.allowed_security_group_ids[count.index]
}

resource "aws_db_subnet_group" "this" {
  name        = "n8n-${terraform.workspace}"
  description = "Subredes privadas de RDS"
  subnet_ids  = var.subnet_ids

  tags = {
    Name = "RDS-Subnets-${terraform.workspace}"
  }
}

resource "aws_db_parameter_group" "this" {
  name        = "n8n-postgres-${terraform.workspace}"
  family      = var.parameter_family
  description = "PostgreSQL de n8n sin forzar SSL dentro de la VPC"

  parameter {
    name         = "rds.force_ssl"
    value        = "0"
    apply_method = "pending-reboot"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_instance" "this" {
  identifier        = "n8n-${terraform.workspace}"
  engine            = "postgres"
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = var.db_name
  username = var.username
  password = random_password.db.result

  db_subnet_group_name   = aws_db_subnet_group.this.name
  parameter_group_name   = aws_db_parameter_group.this.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  publicly_accessible = false
  multi_az            = false

  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false
  apply_immediately       = true

  tags = {
    Name = "RDS-${terraform.workspace}"
  }
}
