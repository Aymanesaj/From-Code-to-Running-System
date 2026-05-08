terraform {
  required_version = ">= 1.5.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.0"
    }
  }
}

resource "oci_load_balancer_load_balancer" "lb" {
  compartment_id = var.compartment_id
  display_name   = "sysrun-lb"
  shape          = "flexible"
  shape_details {
    maximum_bandwidth_in_mbps = 1000
    minimum_bandwidth_in_mbps = 100
  }
  subnet_ids = [var.public_subnet]
  is_private = false
}

resource "oci_load_balancer_backend_set" "sysrun_backend_set" {
  name             = "sysrun-backend-set"
  load_balancer_id = oci_load_balancer_load_balancer.lb.id

  policy = "ROUND_ROBIN"

  health_checker {
    protocol = "HTTP"
    port     = 8080
    url_path = "/health"

    retries           = 3
    timeout_in_millis = 3000
    interval_ms       = 10000

    return_code = 200
  }
}

resource "oci_load_balancer_backend" "sysrun_backend" {
  load_balancer_id = oci_load_balancer_load_balancer.lb.id
  backendset_name  = oci_load_balancer_backend_set.sysrun_backend_set.name

  ip_address = var.private_ip
  port       = 8080

  weight = 1
}

resource "oci_load_balancer_listener" "http_listener" {
  load_balancer_id         = oci_load_balancer_load_balancer.lb.id
  name                     = "http-listener"
  default_backend_set_name = oci_load_balancer_backend_set.sysrun_backend_set.name

  port     = 80
  protocol = "HTTP"
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