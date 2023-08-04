resource "openstack_networking_rbac_policy_v2" "rbac_policy" {
  action        = "access_as_shared"
  object_id     = var.network_id
  object_type   = "network"
  target_tenant = var.project_id
}
