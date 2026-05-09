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
    port     = 80
    url_path = "/healthz"

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
  port       = 80

  weight = 1
}

resource "oci_load_balancer_listener" "http_listener" {
  load_balancer_id         = oci_load_balancer_load_balancer.lb.id
  name                     = "http-listener"
  default_backend_set_name = oci_load_balancer_backend_set.sysrun_backend_set.name

  port     = 80
  protocol = "HTTP"
}