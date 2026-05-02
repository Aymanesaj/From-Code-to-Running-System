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
