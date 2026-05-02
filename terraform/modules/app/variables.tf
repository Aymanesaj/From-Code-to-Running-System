variable "compartment_id" {
  description = "OCI Compartment OCID"
  type        = string
}

variable "subnet_id" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "instance_shape" {
  type = string
  default = "VM.Standard.A1.Flex"
}

variable "ocpus" {
  type = number
  default = 4
}

variable "memory_in_gbs" {
  type = number
  default = 24
}
