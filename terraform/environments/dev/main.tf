module "network" {
  source = "../../modules/network"

  compartment_id   = var.compartment_id
  region           = var.region
  vcn_display_name = "sysrun-dev-vcn"
}

module "app" {
  source = "../../modules/app"
  subnet_id = module.network.subnet_id
  compartment_id = var.compartment_id
  ssh_public_key = var.ssh_public_key
}