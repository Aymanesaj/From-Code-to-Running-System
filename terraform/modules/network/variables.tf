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

variable "dns_label" {
  type    = string
  default = "internal"
}

variable "region" {
  description = "OCI region"
  type        = string
  default     = "af-casablanca-1"
}

variable "name_prefix" {
  type        = string
  description = "Project/service prefix"
  default     = "sysrun"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"
}

variable "public_subnet_cidr" {
  type    = string
  default = "172.16.1.0/24"
}

variable "private_subnet_cidr" {
  type    = string
  default = "172.16.2.0/24"
}

variable "app_port" {
  type    = number
  default = 8080
}

variable "owner" {
  type    = string
  default = "sysops"
}