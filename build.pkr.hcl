build {
  source "docker.base" {
    name = "base"

  }

  provisioner "shell" {
    inline = [
      "apk add --no-cache jq curl openssl openssh-client sshfs iptables make git xorriso",
      "curl -sSL https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o /usr/local/bin/cloudflared",
      "curl -sSL https://pkgs.tailscale.com/stable/tailscale_${var.tailscale_version}_amd64.tgz -o tailscale_${var.tailscale_version}_amd64.tgz",
      "tar xzf tailscale_${var.tailscale_version}_amd64.tgz",
      "chmod +x tailscale_${var.tailscale_version}_amd64/tailscale tailscale_${var.tailscale_version}_amd64/tailscaled",
      "mv tailscale_${var.tailscale_version}_amd64/tailscale tailscale_${var.tailscale_version}_amd64/tailscaled /usr/local/bin && rm -rf tailscale_${var.tailscale_version}_amd64 tailscale_${var.tailscale_version}_amd64.tgz",
      "chmod +x /usr/local/bin/cloudflared"
    ]
  }

  post-processors {
    post-processor "docker-tag" {
      repository = var.repository
      tags       = ["base"]
    }

    post-processor "docker-push" {
      login          = true
      login_server   = var.registry
      login_username = var.username
      login_password = var.password
    }
  }
}

build {
  source "docker.packer" {
    name = "packer"
  }

  provisioner "shell" {
    inline = [
      "curl -sSL https://releases.hashicorp.com/packer/${var.packer_version}/packer_${var.packer_version}_linux_amd64.zip -o packer_${var.packer_version}_linux_amd64.zip",
      "curl -sSL https://releases.hashicorp.com/terraform/${var.terraform_version}/terraform_${var.terraform_version}_linux_amd64.zip -o terraform_${var.terraform_version}_linux_amd64.zip",
      "unzip packer_${var.packer_version}_linux_amd64.zip && unzip terraform_${var.terraform_version}_linux_amd64.zip && chmod +x packer terraform && mv packer terraform /usr/local/bin/",
      "rm -rf packer_${var.packer_version}_linux_amd64.zip terraform_${var.terraform_version}_linux_amd64.zip"
    ]
  }

  post-processors {
    post-processor "docker-tag" {
      repository = var.repository
      tags       = ["packer"]
    }

    post-processor "docker-push" {
      login          = true
      login_server   = var.registry
      login_username = var.username
      login_password = var.password
    }
  }
}

build {
  source "docker.terraform" {
    name = "terraform"
  }

  provisioner "shell" {
    inline = [
      "curl -sSL https://gitlab.com/gitlab-org/terraform-images/-/raw/master/src/bin/gitlab-terraform.sh -o /usr/local/bin/gitlab-terraform",
      "curl -sSL https://releases.hashicorp.com/terraform/${var.terraform_version}/terraform_${var.terraform_version}_linux_amd64.zip -o terraform_${var.terraform_version}_linux_amd64.zip",
      "unzip terraform_${var.terraform_version}_linux_amd64.zip && mv terraform /usr/local/bin/ && chmod +x /usr/local/bin/terraform /usr/local/bin/gitlab-terraform",
      "rm -rf terraform_${var.terraform_version}_linux_amd64.zip"
    ]
  }

  post-processors {

    post-processor "docker-tag" {
      repository = var.repository
      tags       = ["terraform"]
    }

    post-processor "docker-push" {
      login          = true
      login_server   = var.registry
      login_username = var.username
      login_password = var.password
    }
  }
}

build {
  source "docker.provisioner" {
    name = "provisioner"
  }

  provisioner "shell" {
    inline = [
      "apk add --no-cache ansible",
      "curl -sSL https://github.com/cloudflare/cfssl/releases/download/v${var.cfssl_version}/cfssl_${var.cfssl_version}_linux_amd64 -o /usr/local/bin/cfssl",
      "curl -sSL https://github.com/cloudflare/cfssl/releases/download/v${var.cfssl_version}/cfssljson_${var.cfssl_version}_linux_amd64 -o /usr/local/bin/cfssljson",
      "curl -sSL https://releases.hashicorp.com/consul/${var.consul_version}/consul_${var.consul_version}_linux_amd64.zip -o consul_${var.consul_version}_linux_amd64.zip",
      "curl -sSL https://releases.hashicorp.com/nomad/${var.nomad_version}/nomad_${var.nomad_version}_linux_amd64.zip -o nomad_${var.nomad_version}_linux_amd64.zip",
      "curl -sSL https://releases.hashicorp.com/vault/${var.vault_version}/vault_${var.vault_version}_linux_amd64.zip -o vault_${var.vault_version}_linux_amd64.zip",
      "unzip consul_${var.consul_version}_linux_amd64.zip && unzip nomad_${var.nomad_version}_linux_amd64.zip && unzip vault_${var.vault_version}_linux_amd64.zip",
      "chmod +x consul nomad vault && mv consul nomad vault /usr/local/bin/",
      "chmod +x /usr/local/bin/cfssl /usr/local/bin/cfssljson",
      "rm -rf consul_${var.consul_version}_linux_amd64.zip nomad_${var.nomad_version}_linux_amd64.zip vault_${var.vault_version}_linux_amd64.zip"
    ]
  }

  post-processors {
    post-processor "docker-tag" {
      repository = var.repository
      tags       = ["provisioner"]
    }

    post-processor "docker-push" {
      login          = true
      login_server   = var.registry
      login_username = var.username
      login_password = var.password
    }
  }
}
