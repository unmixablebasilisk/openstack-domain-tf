terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.49.0"
    }
  }
}

provider "openstack" {
  insecure = "true"
}

provider "openstack" {
  alias     = "tenant"
  insecure  = "true"
  tenant_id = openstack_identity_project_v3.admin_project.id
}
