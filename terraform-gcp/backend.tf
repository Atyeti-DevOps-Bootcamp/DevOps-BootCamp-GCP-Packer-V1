terraform {
  cloud {
    organization = "Devops_Packer"

    workspaces {
      name = "Packer-GCP"
    }
  }
}
#