output "vm_name" {
  description = "Name of the created VM"
  value       = module.packer_vm.vm_name
}

output "vm_ip" {
  description = "External IP of the created VM"
  value       = module.packer_vm.vm_ip
}
