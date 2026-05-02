terraform {
  required_version = ">= 1.5.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.0"
    }
  }
}

resource "oci_core_vcn" "internal" {
  dns_label      = var.dns_label
  cidr_block     = var.cidr_block
  compartment_id = var.compartment_id
  display_name   = var.vcn_display_name

  freeform_tags = {
    environment = "dev"
    project     = "terraform-learning"
  }
}

resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_id
  vcn_id = oci_core_vcn.internal.id
}

resource "oci_core_route_table" "tables" {
  vcn_id = oci_core_vcn.internal.id
  compartment_id = var.compartment_id
  route_rules {
    destination = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}

resource "oci_core_security_list" "seclist" {
  compartment_id = var.compartment_id
  vcn_id = oci_core_vcn.internal.id
  ingress_security_rules {
    protocol = "6"
    source = "0.0.0.0/0"
    description = "Allow HTTP"
    stateless   = false
    tcp_options {
      min = 80
      max = 80
    }
  }
  ingress_security_rules {
    protocol = "6"
    source = "0.0.0.0/0"
    description = "Allow ssh"
    stateless   = false
    tcp_options {
      min = 22
      max = 22
    }
  }
  egress_security_rules {
    protocol = "all"
    destination = "0.0.0.0/0"
  }

}

resource "oci_core_subnet" "subnet" {
  compartment_id = var.compartment_id
  cidr_block = "172.16.1.0/24"
  vcn_id = oci_core_vcn.internal.id
  route_table_id = oci_core_route_table.tables.id
  security_list_ids = [oci_core_security_list.seclist.id]
}