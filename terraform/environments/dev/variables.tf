variable "region" {
  description = "OCI region"
  type        = string
  default     = "af-casablanca-1"
}

variable "compartment_id" {
  description = "OCI Compartment OCID"
  type        = string
}

variable "ssh_public_key" {
  type = string
}

variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}