variable "image" {
  type    = string
  default = "alpine"
}

variable "repository" {
  type    = string
}

variable "registry" {
  type    = string
}

variable "username" {
  type    = string
}

variable "password" {
  type    = string
}

variable "packer_version" {
  type    = string
}

variable "terraform_version" {
  type    = string
}

variable "consul_version" {
  type    = string
}

variable "nomad_version" {
  type    = string
}

variable "tailscale_version" {
  type    = string
}

variable "vault_version" {
  type    = string
}

variable "cfssl_version" {
  type    = string
}

variable "ct_version" {
  type    = string
}
