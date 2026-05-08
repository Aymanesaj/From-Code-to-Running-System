output "instance_public_ip" {
  value = oci_core_instance.my_vm.public_ip
}

output "instance_id" {
  value = oci_core_instance.my_vm.id
}

output "private_ip" {
  value = oci_core_instance.my_vm.private_ip
}