module "network" {
  source = "../../modules/network"

  compartment_id   = var.compartment_id
  region           = var.region
  vcn_display_name = "sysrun-dev-vcn"
}

module "app" {
  source         = "../../modules/app"
  private_subnet = module.network.private_subnet
  compartment_id = var.compartment_id
  ssh_public_key = var.ssh_public_key
}

module "lb" {
  source         = "../../modules/lb"
  private_ip     = module.app.private_ip
  compartment_id = var.compartment_id
  public_subnet  = module.network.public_subnet
  instance_id    = module.app.instance_id
  ssh_public_key = var.ssh_public_key
  private_subnet = module.network.private_subnet
}

module "bastion" {
  source         = "../../modules/bastion"
  ssh_public_key = var.ssh_public_key
  private_subnet = module.network.private_subnet
  private_ip = module.app.private_ip
  compartment_id = var.compartment_id
}