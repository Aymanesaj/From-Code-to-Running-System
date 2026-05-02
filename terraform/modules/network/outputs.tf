output "vcn_id" {
  value = oci_core_vcn.internal.id
}

output "subnet_id" {
  value = oci_core_subnet.subnet.id
}