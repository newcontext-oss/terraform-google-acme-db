terraform {
  required_version = ">= 0.10.2, < 0.12"
}

provider "google" {
  credentials = "${file("${var.google_application_credentials}")}"
  project     = "${var.gcloud_project}"
  region      = "${var.gcloud_region}"
  version     = "~> 1.0"
}


module "network" {
  organization_name = "test-org"
  source            = "git::ssh://git@github.com/newcontext/tf_module_gcloud_network.git?ref=ncs-alane-make-or-break"
}

module "db" {
  engineer_cidrs          = "${var.engineer_cidrs}"
  source                  = "../../.."
  ssh_public_key_filepath = "${path.module}/files/insecure.pub"
  subnetwork_name         = "${module.network.database_subnetwork_name}"
}
