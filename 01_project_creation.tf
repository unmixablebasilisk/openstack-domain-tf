#### Domain and Projects
resource "openstack_identity_project_v3" "domain" {
  name        = var.domain_name
  description = "Domain for ${var.domain_name}"
  is_domain   = "true"
  enabled     = "true"

  provisioner "local-exec" {
    when    = destroy
    command = "openstack domain set --disable ${self.name} --insecure"
  }
}

resource "openstack_identity_project_v3" "admin_project" {
  name        = "${var.domain_name}-admin"
  description = "Admin project for ${var.domain_name}"
  domain_id   = openstack_identity_project_v3.domain.id
}

resource "openstack_identity_project_v3" "project" {
  name        = "${var.project_name}-${var.os_environment}"
  description = "Project for ${var.project_name}"
  domain_id   = openstack_identity_project_v3.domain.id
  parent_id   = openstack_identity_project_v3.admin_project.id
}

#### Role Assignment
resource "openstack_identity_role_assignment_v3" "role_assignment_admin" {
  user_id    = var.admin_user_id
  project_id = openstack_identity_project_v3.admin_project.id
  role_id    = var.admin_role_id
}

resource "openstack_identity_role_assignment_v3" "role_assignment_project" {
  user_id    = var.admin_user_id
  project_id = openstack_identity_project_v3.project.id
  role_id    = var.admin_role_id
}

resource "openstack_identity_role_assignment_v3" "user_role_assignment_admin" {
  user_id    = data.openstack_identity_user_v3.user.id
  project_id = openstack_identity_project_v3.admin_project.id
  role_id    = var.admin_role_id
}

resource "openstack_identity_role_assignment_v3" "user_role_assignment_project" {
  user_id    = data.openstack_identity_user_v3.user.id
  project_id = openstack_identity_project_v3.project.id
  role_id    = var.admin_role_id
}

#### Set Project Quotas
resource "openstack_compute_quotaset_v2" "quota_compute" {
  project_id           = openstack_identity_project_v3.project.id
  key_pairs            = 10
  ram                  = 32768
  cores                = 32
  instances            = 10
  server_groups        = 0
  server_group_members = 0
}

resource "openstack_blockstorage_quotaset_v3" "quota_storage" {
  project_id = openstack_identity_project_v3.project.id
  volumes    = 20
  snapshots  = 20
  gigabytes  = 2048
}

resource "openstack_networking_quota_v2" "quota_network" {
  project_id          = openstack_identity_project_v3.project.id
  floatingip          = 1
  network             = 1
  port                = 5
  router              = 1
  security_group      = 10
  security_group_rule = 50
  subnet              = 1
}
