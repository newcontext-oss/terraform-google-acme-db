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
