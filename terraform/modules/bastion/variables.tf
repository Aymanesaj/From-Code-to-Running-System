variable "bastion_client_cidr_allow_list" {
  description = "Unique CIDR blocks allowed to open Bastion sessions (max 20)."
  type        = list(string)
  default     = ["0.0.0.0/0"]

  validation {
    condition = (
      length(var.bastion_client_cidr_allow_list) > 0 &&
      length(var.bastion_client_cidr_allow_list) <= 20 &&
      length(distinct(var.bastion_client_cidr_allow_list)) == length(var.bastion_client_cidr_allow_list) &&
      alltrue([for cidr in var.bastion_client_cidr_allow_list : can(cidrhost(cidr, 0))])
    )
    error_message = "Provide 1-20 unique CIDR blocks in valid CIDR notation (for example: [\"203.0.113.10/32\"])."
  }
}

variable "private_ip" {
  type = string
}

variable "compartment_id" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "private_subnet" {
  type = string
}