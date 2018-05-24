provider "google" {
  credentials = "${file("${var.google_application_credentials}")}"
  project     = "${var.gcloud_project}"
  region      = "${var.gcloud_region}"
  version     = "~> 1.0"
}

module "db" {
  source = "../../.."

  network_name = "test-org"

  engineer_cidrs = "${var.engineer_cidrs}"
  ssh_public_key_filepath = "${path.module}/files/insecure.pub"
}
