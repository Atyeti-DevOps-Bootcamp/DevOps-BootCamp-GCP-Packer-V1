output "vm_name" {
  value = google_compute_instance.packer_vm.name
}

output "vm_ip" {
  value = google_compute_instance.packer_vm.network_interface[0].access_config[0].nat_ip
}
