variable "vm_name" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "zone" {
  type = string
}

variable "project_id" {
  type = string
}

variable "image_name" {
  type = string
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}
