output "vcn_id" {
  value = oci_core_vcn.internal.id
}

output "private_subnet" {
  value = oci_core_subnet.private_subnet.id
}

output "public_subnet" {
  value = oci_core_subnet.public_subnet.id
}
