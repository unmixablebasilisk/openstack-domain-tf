data "openstack_networking_network_v2" "ext_network" {
  name = var.external_network_name
}

data "openstack_networking_subnet_ids_v2" "ext_subnets" {
  network_id = data.openstack_networking_network_v2.ext_network.id
}

data "openstack_identity_project_v3" "user_domain" {
  name      = var.user_domain
  is_domain = true
}

data "openstack_identity_user_v3" "user" {
  name      = var.os_username
  domain_id = data.openstack_identity_project_v3.user_domain.id
}

data "openstack_networking_secgroup_v2" "admin_secgroup" {
  name      = "default"
  tenant_id = openstack_identity_project_v3.admin_project.id
}

data "openstack_networking_secgroup_v2" "project_secgroup" {
  name      = "default"
  tenant_id = openstack_identity_project_v3.project.id
}

data "openstack_images_image_v2" "image" {
  name        = var.image_name
  most_recent = true
}
