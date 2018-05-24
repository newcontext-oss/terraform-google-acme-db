data "google_compute_network" "main" {
  name = "${var.network_name}"
}

data "google_compute_subnetwork" "db" {
  name = "db"
}

resource "google_compute_instance" "db" {
  name         = "db"
  machine_type = "n1-standard-1"
  zone         = "us-west1-a"

  allow_stopping_for_update = true

  labels = {
    name = "db"
  }

  tags = ["db"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1604-lts"
    }
  }

  // Local SSD disk
  scratch_disk {}

  network_interface {
    subnetwork = "${data.google_compute_subnetwork.db.self_link}"

    access_config {
      // Ephemeral IP
    }
  }

  metadata {
    sshKeys                = "ubuntu:${file(var.ssh_public_key_filepath)}"
    block-project-ssh-keys = "TRUE"
    startup-script         = "${file("${path.module}/files/install.sh")}"
  }
}

resource "google_compute_firewall" "db_tcp22_ingress" {
  name    = "db-tcp22-ingress"
  network = "${data.google_compute_network.main.name}"

  direction = "INGRESS"

  priority = 999

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = "${var.engineer_cidrs}"

  target_tags = ["db"]
}

resource "google_compute_firewall" "db_tcp8080_ingress" {
  name    = "db-tcp8080-ingress"
  network = "${data.google_compute_network.main.name}"

  direction = "INGRESS"

  priority = 998

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = "${var.engineer_cidrs}"

  target_tags = ["db"]
}
