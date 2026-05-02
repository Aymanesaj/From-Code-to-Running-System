variable "cidr_block" {
  description = "CIDR block for the VCN"
  type        = string
  default     = "172.16.0.0/20"
}

variable "compartment_id" {
  description = "OCI Compartment OCID"
  type        = string
}

variable "vcn_display_name" {
  description = "VCN display name"
  type        = string
  default     = "dev-vcn"
}

variable "dns_label"{
  type = string
  default = "internal"
}

variable "region" {
  description = "OCI region"
  type        = string
  default     = "af-casablanca-1"
}