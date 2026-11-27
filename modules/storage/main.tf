resource "aws_security_group" "efs" {
  name_prefix = "sec-efs-${terraform.workspace}-"
  description = "NFS hacia EFS desde los nodos de k3s"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG-EFS-${terraform.workspace}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "nfs" {
  count = length(var.allowed_security_group_ids)

  description              = "NFS desde los nodos"
  type                     = "ingress"
  security_group_id        = aws_security_group.efs.id
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = var.allowed_security_group_ids[count.index]
}

resource "aws_efs_file_system" "this" {
  creation_token   = "n8n-efs-${terraform.workspace}"
  encrypted        = true
  performance_mode = var.performance_mode
  throughput_mode  = var.throughput_mode

  tags = {
    Name = "EFS-${terraform.workspace}"
  }
}

resource "aws_efs_mount_target" "this" {
  count = length(var.subnet_ids)

  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = var.subnet_ids[count.index]
  security_groups = [aws_security_group.efs.id]
}
