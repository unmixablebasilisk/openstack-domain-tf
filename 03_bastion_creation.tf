module "bastion" {
  source        = "./modules/bastion"
  instance_name = "${var.domain_name}-bastion-${var.os_environment}"
  flavor_name   = var.flavor_name
  keypair_name  = var.keypair_name
  network_name  = openstack_networking_network_v2.admin_network.name
  image_name    = var.image_name
  image_id      = data.openstack_images_image_v2.image.id
  volume_size   = var.volume_size
  providers = {
    openstack = openstack.tenant
  }
  depends_on = [openstack_identity_role_assignment_v3.user_role_assignment_admin]
}

#### Allocate and assign Floating IP
resource "openstack_networking_floatingip_v2" "floatip" {
  tenant_id  = openstack_identity_project_v3.admin_project.id
  pool       = var.subnetpool_name
  subnet_ids = data.openstack_networking_subnet_ids_v2.ext_subnets.ids
}

resource "openstack_compute_floatingip_associate_v2" "floatip_associate" {
  floating_ip = openstack_networking_floatingip_v2.floatip.address
  instance_id = module.bastion.bastion_id
}

#### Set security group rules
resource "openstack_networking_secgroup_rule_v2" "admin_secgroup_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = data.openstack_networking_secgroup_v2.admin_secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "project_secgroup_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "${module.bastion.bastion_ip}/32"
  security_group_id = data.openstack_networking_secgroup_v2.project_secgroup.id
}
