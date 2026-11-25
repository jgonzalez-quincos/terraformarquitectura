resource "aws_security_group" "master" {
  name_prefix = "sg-master-${terraform.workspace}-"
  description = "Master de k3s"
  vpc_id      = var.vpc_id

  egress {
    description = "Salida a internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG-Master-${terraform.workspace}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "worker" {
  name_prefix = "sg-worker-${terraform.workspace}-"
  description = "Workers de k3s"
  vpc_id      = var.vpc_id

  egress {
    description = "Salida a internet por el NAT"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG-Worker-${terraform.workspace}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "master_ssh" {
  description       = "SSH desde la IP de administracion"
  type              = "ingress"
  security_group_id = aws_security_group.master.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.admin_cidr]
}

resource "aws_security_group_rule" "master_api" {
  description       = "API de Kubernetes"
  type              = "ingress"
  security_group_id = aws_security_group.master.id
  from_port         = 6443
  to_port           = 6443
  protocol          = "tcp"
  cidr_blocks       = [var.admin_cidr]
}

resource "aws_security_group_rule" "master_n8n" {
  description       = "NodePort publicado de n8n"
  type              = "ingress"
  security_group_id = aws_security_group.master.id
  from_port         = 30678
  to_port           = 30678
  protocol          = "tcp"
  cidr_blocks       = [var.nodeport_cidr]
}

resource "aws_security_group_rule" "master_from_worker" {
  description              = "Trafico del cluster desde los workers"
  type                     = "ingress"
  security_group_id        = aws_security_group.master.id
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.worker.id
}

resource "aws_security_group_rule" "worker_from_master" {
  description              = "Trafico del cluster desde el master"
  type                     = "ingress"
  security_group_id        = aws_security_group.worker.id
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.master.id
}

resource "aws_security_group_rule" "worker_from_worker" {
  description              = "Trafico entre workers"
  type                     = "ingress"
  security_group_id        = aws_security_group.worker.id
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.worker.id
}
