terraform {
  required_version = ">= 1.5.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.0"
    }
  }
}

locals {
  common_tags = {
    project     = var.name_prefix
    environment = var.environment
    managed_by  = "terraform"
    owner       = var.owner
  }
}

resource "oci_core_vcn" "internal" {
  dns_label      = var.dns_label
  cidr_block     = var.cidr_block
  compartment_id = var.compartment_id
  display_name   = var.vcn_display_name

  freeform_tags = local.common_tags
}

resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.internal.id
}

resource "oci_core_route_table" "public_rt" {
  vcn_id         = oci_core_vcn.internal.id
  compartment_id = var.compartment_id
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}

resource "oci_core_security_list" "seclist" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.internal.id
  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    description = "Allow HTTP"
    stateless   = false
    tcp_options {
      min = 80
      max = 80
    }
  }
  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }
}

resource "oci_core_security_list" "private_seclist" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.internal.id
  display_name   = "${var.name_prefix}-${var.environment}-private-seclist"
  ingress_security_rules {
    protocol    = "6"
    source      = var.public_subnet_cidr
    description = "Allow nginx traffic from LB subnet"
    tcp_options {
      min = 80
      max = 80
    }
  }
  ingress_security_rules {
    protocol    = "6"
    source      = var.public_subnet_cidr
    description = "Allow app traffic from LB subnet"
    tcp_options {
      min = var.app_port
      max = var.app_port
    }
  }
  ingress_security_rules {
    protocol    = "6"
    source      = var.private_subnet_cidr
    description = "Allow SSH from bastion-managed path"
    tcp_options {
      min = 22
      max = 22
    }
  }

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
    description = "Allow outbound traffic"
  }

  freeform_tags = local.common_tags
}

resource "oci_core_subnet" "public_subnet" {
  compartment_id    = var.compartment_id
  cidr_block        = var.public_subnet_cidr
  vcn_id            = oci_core_vcn.internal.id
  route_table_id    = oci_core_route_table.public_rt.id
  security_list_ids = [oci_core_security_list.seclist.id]
}

resource "oci_core_nat_gateway" "nat_gw" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.internal.id
  display_name   = "sysrun-nat-gw"
}

resource "oci_core_route_table" "private_rt" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.internal.id
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_nat_gateway.nat_gw.id
  }
}

resource "oci_core_subnet" "private_subnet" {
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.internal.id
  cidr_block                 = var.private_subnet_cidr
  route_table_id             = oci_core_route_table.private_rt.id
  display_name               = "sysrun-private-subnet"
  prohibit_public_ip_on_vnic = true
  security_list_ids          = [oci_core_security_list.private_seclist.id]
}
