output load_balancer_external_ip {
  description = "The external ip address of the forwarding rule (Load Balancer)."
  value       = "${module.dev-autoscaler.load_balancer_external_ip}"
}

output available_zones {
  value       = "${module.dev-autoscaler.available_zones}"
}