output "lb-dns" {
  value = aws_elb.main_elb.dns_name
}

