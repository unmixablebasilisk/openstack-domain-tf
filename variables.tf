#### REQUIRED VARS
variable "domain_name" {
  description = "Domain name"
  type        = string
}

variable "project_name" {
  description = "Tenant project name"
  type        = string
}

variable "os_environment" {
  description = "Specify dev or prod. This is used for naming of objects only."
  type        = string
}

variable "os_username" {
  description = "Your Openstack user name:"
  type        = string
}

variable "admin_subnet_cidr" {
  #### Change this variable!
  #### Before setting this variable, use this command to check which subnets are already in-use to avoid IP conflicts:
  #### openstack subnet list --insecure | grep 192.168 | awk '{ print $8 }' | sort
  # e.g. default     = "192.168.80.0/24"
  description = "Admin project subnet"
  type        = string
}

################################################################################

variable "user_domain" {
  description = "Domain your username belongs to"
  type        = string
  default     = "users"
}

##### BASTION VARS
variable "flavor_name" {
  description = "Flavor to use for Bastion instance"
  type        = string
  default     = "m1.small"
}

variable "keypair_name" {
  type    = string
}

variable "image_name" {
  description = "Image to use for Bastion instance"
  type        = string
}

variable "volume_size" {
  description = "The size of volume used to instantiate the instance"
}

################################################################################

#### NETWORK VARS
variable "dns_nameservers" {
  type    = list(any)
  default = ["1.1.1.1", "8.8.8.8"]
}

variable "external_network_name" {
  type    = string
}

variable "subnetpool_id" {
  description = "Subnet pool for admin network"
  type        = string
}

variable "admin_user_id" {
  description = "Admin user ID"
  type        = string
}

variable "admin_role_id" {
  description = "Admin user role ID"
  type        = string
}

variable "subnetpool_name" {
  type = string
}
