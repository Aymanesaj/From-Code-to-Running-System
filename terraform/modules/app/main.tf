terraform {
  required_version = ">= 1.5.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.0"
    }
  }
}

data "oci_identity_availability_domain" "availability_domain" {
  compartment_id = var.compartment_id
  ad_number      = 1
}

data "oci_core_images" "image" {
  compartment_id           = var.compartment_id
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  shape                    = var.instance_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance" "my_vm" {
  compartment_id      = var.compartment_id
  availability_domain = data.oci_identity_availability_domain.availability_domain.name
  shape               = var.instance_shape
  create_vnic_details {
    subnet_id        = var.private_subnet
    assign_public_ip = false
  }
  shape_config {
    ocpus         = var.ocpus
    memory_in_gbs = var.memory_in_gbs
  }
  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.image.images[0].id
  }
  agent_config {
    is_management_disabled = false
    is_monitoring_disabled = false

    plugins_config {
      name          = "Bastion"
      desired_state = "ENABLED"
    }
  }
  metadata = {
    user_data           = base64encode(file("${path.module}/setup.sh"))
    ssh_authorized_keys = var.ssh_public_key
  }
}

