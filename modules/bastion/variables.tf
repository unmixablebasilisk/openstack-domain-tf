variable "instance_name" {
  description = "The Instance Name to be used."
}

variable "flavor_name" {
  description = "The flavor id to be used."
}

variable "keypair_name" {
  description = "The keypair to be used."
}

variable "network_name" {
  description = "The network to be used."
}

variable "image_name" {
  description = "Image name to use for Bastion instance"
}

variable "image_id" {
  description = "The image ID to be used."
}

variable "volume_size" {
  description = "The size of volume used to instantiate the instance"
}
