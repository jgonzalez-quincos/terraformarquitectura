data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-6.1-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "random_password" "k3s_token" {
  length  = 32
  special = false
}

resource "aws_instance" "master" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.master_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.master_sg_id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  user_data_replace_on_change = true

  user_data = templatefile("${path.module}/templates/master.sh.tpl", {
    k3s_token = random_password.k3s_token.result
  })

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
    encrypted   = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "k3s-master-${terraform.workspace}"
    Role = "master"
  }
}

resource "aws_instance" "worker" {
  count = var.worker_count

  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.worker_type
  subnet_id                   = var.private_subnet_ids[count.index % length(var.private_subnet_ids)]
  vpc_security_group_ids      = [var.worker_sg_id]
  key_name                    = var.key_name
  associate_public_ip_address = false
  user_data_replace_on_change = true

  user_data = templatefile("${path.module}/templates/worker.sh.tpl", {
    k3s_token         = random_password.k3s_token.result
    master_private_ip = aws_instance.master.private_ip
  })

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
    encrypted   = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "k3s-worker-${terraform.workspace}-${count.index}"
    Role = "worker"
  }
}
