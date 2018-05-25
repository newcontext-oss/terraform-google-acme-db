output "allow_ssh_ingress_firewall_rule_name" {
  description = "The name of the firewall rule which allows SSH ingress."
  value       = "${module.db.allow_ssh_ingress_firewall_rule_name}"
}

output "allow_ui_ingress_firewall_rule_name" {
  description = "The name of the firewall rule which allows UI ingress."
  value       = "${module.db.allow_ui_ingress_firewall_rule_name}"
}

output "database_name" {
  description = "The name of the database compute instance."
  value       = "${module.db.name}"
}

output "network_name" {
  description = "The name of the network in which resources are deployed."
  value       = "${module.network.name}"
}
