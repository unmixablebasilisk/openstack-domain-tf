#### Networks
resource "openstack_networking_network_v2" "admin_network" {
  name           = "${var.domain_name}-admin-network"
  admin_state_up = "true"
  tenant_id      = openstack_identity_project_v3.admin_project.id
}

resource "openstack_networking_network_v2" "project_network" {
  name           = "${var.project_name}-${var.os_environment}-network"
  admin_state_up = "true"
  tenant_id      = openstack_identity_project_v3.admin_project.id
}

#### Subnets
resource "openstack_networking_subnet_v2" "admin_subnet" {
  name            = "${var.domain_name}-admin-subnet"
  network_id      = openstack_networking_network_v2.admin_network.id
  cidr            = var.admin_subnet_cidr
  tenant_id       = openstack_identity_project_v3.admin_project.id
  dns_nameservers = var.dns_nameservers
}

resource "openstack_networking_subnet_v2" "project_subnet" {
  name            = "${var.project_name}-${var.os_environment}-subnet"
  network_id      = openstack_networking_network_v2.project_network.id
  tenant_id       = openstack_identity_project_v3.admin_project.id
  dns_nameservers = var.dns_nameservers
  subnetpool_id   = var.subnetpool_id
}

#### Router
resource "openstack_networking_router_v2" "admin_router" {
  name                = "${var.domain_name}-admin-router"
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.ext_network.id
  tenant_id           = openstack_identity_project_v3.admin_project.id
}

resource "openstack_networking_router_interface_v2" "router_interface_admin" {
  router_id = openstack_networking_router_v2.admin_router.id
  subnet_id = openstack_networking_subnet_v2.admin_subnet.id
}

resource "openstack_networking_router_interface_v2" "router_interface_project" {
  router_id = openstack_networking_router_v2.admin_router.id
  subnet_id = openstack_networking_subnet_v2.project_subnet.id
}

module "RBAC_policy" {
  source     = "./modules/rbac"
  network_id = openstack_networking_network_v2.project_network.id
  project_id = openstack_identity_project_v3.project.id
  providers = {
    openstack = openstack.tenant
  }
}
