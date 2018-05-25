output "allow_ssh_ingress_firewall_rule_name" {
  description = "The name of the firewall rule which allows SSH ingress."
  value       = "${google_compute_firewall.allow_ssh_ingress.name}"
}

output "allow_ui_ingress_firewall_rule_name" {
  description = "The name of the firewall rule which allows UI ingress."
  value       = "${google_compute_firewall.allow_ui_ingress.name}"
}

output "name" {
  description = "The name of the database compute instance."
  value       = "${google_compute_instance.db.name}"
}

output "external_ip" {
  value = "${google_compute_instance.db.network_interface.0.access_config.0.assigned_nat_ip}"
}

output "internal_ip" {
  value = "${google_compute_instance.db.network_interface.0.address}"
}
