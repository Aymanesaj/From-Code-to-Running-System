output "lb_id" {
  value = oci_load_balancer_load_balancer.lb.id
}

output "backend_set_id" {
  value = oci_load_balancer_backend_set.sysrun_backend_set.id
}

output "backend_id" {
  value = oci_load_balancer_backend.sysrun_backend.id
}

output "listener_id" {
  value = oci_load_balancer_listener.http_listener.id
}