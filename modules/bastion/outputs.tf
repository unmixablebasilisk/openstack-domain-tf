output "bastion_id" {
  value = openstack_compute_instance_v2.bastion_instance.id
}

output "bastion_ip" {
  value = openstack_compute_instance_v2.bastion_instance.access_ip_v4
}
