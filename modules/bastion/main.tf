resource "openstack_compute_instance_v2" "bastion_instance" {
  name            = var.instance_name
  flavor_name     = var.flavor_name
  key_pair        = var.keypair_name
  network {
    name = var.network_name
  }
  block_device {
    uuid                  = data.openstack_images_image_v2.image.id
    source_type           = "image"
    volume_size           = var.volume_size
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = false
  }
}

data "openstack_images_image_v2" "image" {
  name        = var.image_name
  most_recent = true
}
