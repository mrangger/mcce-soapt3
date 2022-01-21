output "first-dns" {
  value = module.nginx-1.lb-dns
}

output "second-dns" {
  value = module.nginx-2.lb-dns
}

