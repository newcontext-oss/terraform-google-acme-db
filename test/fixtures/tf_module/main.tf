module "db" {
  source = "../../.."

  network_name = "test-org"

  engineer_cidrs = "${var.engineer_cidrs}"
  ssh_public_key_filepath = "${path.module}/files/insecure.pub"
}
