source "docker" "base" {
  image  = "alpine"
  commit = true
  changes = [
    "ENTRYPOINT [\"/bin/sh\", \"-c\"]",
  ]
}

source "docker" "packer" {
  image  = "${var.repository}:base"
  commit = true
  changes = [
    "ENTRYPOINT [\"/bin/sh\", \"-c\"]",
  ]
  login          = true
  login_server   = var.registry
  login_username = var.username
  login_password = var.password
}

source "docker" "terraform" {
  image  = "${var.repository}:base"
  commit = true
  changes = [
    "ENTRYPOINT [\"/bin/sh\", \"-c\"]",
  ]
  login          = true
  login_server   = var.registry
  login_username = var.username
  login_password = var.password
}

source "docker" "provisioner" {
  image  = "${var.repository}:terraform"
  commit = true
  changes = [
    "ENTRYPOINT [\"/bin/sh\", \"-c\"]",
  ]
  login          = true
  login_server   = var.registry
  login_username = var.username
  login_password = var.password
}
