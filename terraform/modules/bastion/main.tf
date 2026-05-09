terraform {
  required_version = ">= 1.5.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.0"
    }
  }
}

resource "oci_bastion_bastion" "bastion" {
  compartment_id                = var.compartment_id
  target_subnet_id              = var.private_subnet
  bastion_type                  = "STANDARD"
  name                          = "sysrun-bastion"
  client_cidr_block_allow_list = var.bastion_client_cidr_allow_list
}

resource "oci_bastion_session" "bastion_session" {
  bastion_id = oci_bastion_bastion.bastion.id
  key_details {
    public_key_content = var.ssh_public_key
  }
  target_resource_details {
    session_type                       = "PORT_FORWARDING"
    target_resource_private_ip_address = var.private_ip
    target_resource_port               = 22
  }
  display_name           = "sysrun-session"
  session_ttl_in_seconds = 3600
}
