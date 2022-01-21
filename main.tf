module "nginx-1" {
  source = "./modules/nginx"
  node_name = "first-node"
}


module "nginx-2" {
  source = "./modules/nginx"
  node_name = "second-node"
}


# Data Source for getting Amazon Linux AMI
data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}


data "vault_generic_secret" "dns-config"{
 path = "kv/dns-config"
}


resource "random_password" "admin-password" {
  length = 16
  special = true
  override_special = "_%@"
}


resource "aws_instance" "docker-host" {
  user_data = templatefile("${path.module}/templates/init.tpl", {domain_name = var.domain_name, email_address = var.email_address, dns_username = data.vault_generic_secret.dns-config.data["username"], dns_password = data.vault_generic_secret.dns-config.data["password"], dns_token = data.vault_generic_secret.dns-config.data["token"], dns_pk = data.vault_generic_secret.dns-config.data["letsencrypt-pk"], admin_password = replace(bcrypt(random_password.admin-password.result, 6), "$", "$$"), node1-url = module.nginx-1.lb-dns, node2-url = module.nginx-2.lb-dns })

  vpc_security_group_ids = [aws_security_group.ingress-all-ssh.id, aws_security_group.ingress-all-traefik.id]

  ami           = data.aws_ami.amazon-2.id
  instance_type = "t3.micro"
  key_name      = "ec2"

  tags = {
    Name = "docker-host"
  }
}


resource "aws_security_group" "ingress-all-ssh" {
  name = "allow-all-ssh"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "ingress-all-traefik" {
  name = "allow-all-traefik"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }
  
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
