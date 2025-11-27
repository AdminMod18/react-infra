variable "project" {
  default = "react-enterprise"
}

variable "location" {
  default = "southcentralus"
}

variable "docker_image" {
  type        = string
  description = "Docker image to deploy"
}

variable "gateway_sku" {
  default = "WAF_v2"
}

variable "gateway_capacity" {
  default = 1
}
