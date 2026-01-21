packer {
  required_plugins {
    googlecompute = {
      source  = "github.com/hashicorp/googlecompute"
      version = "~> 1"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
  }
}

# Secrets injected at build time (from Vault / CI)
variable "admin_password" {
  type      = string
  sensitive = true
}

variable "user1_password" {
  type      = string
  sensitive = true
}

source "googlecompute" "app" {
  project_id = "packer-automation-483407"
  zone       = "us-central1-a"

  image_name   = "packer-ubuntu-app-{{timestamp}}"
  image_family = "packer-ubuntu-app"

  machine_type = "e2-micro"

  #IMPORTANT: Use BASE image
  source_image_family     = "ubuntu-2204-base"
  source_image_project_id = ["packer-automation-483407"]

  ssh_username = "packer"
}

build {
  name    = "gcp-app-image"
  sources = ["source.googlecompute.app"]

  provisioner "ansible" {
    playbook_file = "${path.root}/../../ansible/playbook.yml"
    use_proxy     = false

    extra_arguments = [
      "--become",
      "--extra-vars",
      jsonencode({
        admin_password = var.admin_password
        user1_password = var.user1_password
      }),
      "-e", "ansible_python_interpreter=/usr/bin/python3",
      "-e", "ansible_remote_tmp=/tmp/.ansible"
    ]
  }
}
