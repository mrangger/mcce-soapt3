variable "node_name" {
  description = "Name for nginx node"
  type = string
}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "min_instances" {
  type = number
  default = 1
}

variable "max_instances" {
  type = number
  default = 5
}

variable "desired_instances" {
  type = number
  default = 2
}
