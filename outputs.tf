output "first-dns" {
  value = module.nginx-1.lb-dns
}

output "second-dns" {
  value = module.nginx-2.lb-dns
}

output "admin-password" {
  value = nonsensitive(random_password.admin-password.result)
}


output "ssh-cmd" {
  value = "ssh -i ../ec2.pem ec2-user@${aws_instance.docker-host.public_dns}"
}


output "traefik-url" {
  value = "https://traefik.${var.domain_name}"
}


output "webserver-url" {
  value = "https://webserver.${var.domain_name}"
}

