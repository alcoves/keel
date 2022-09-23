resource "hcloud_placement_group" "dev" {
  name = "dev"
  type = "spread"
  labels = {
    key = "value"
  }
}


resource "hcloud_server" "dev" {
  name                       = "dev"
  keep_disk                  = true
  backups                    = false
  delete_protection          = false
  rebuild_protection         = false
  allow_deprecated_images    = false
  ignore_remote_firewall_ids = false
  location                   = "ash"
  server_type                = "cpx11"
  image                      = "ubuntu-22.04"
  firewall_ids               = [hcloud_firewall.ssh.id]
  placement_group_id         = hcloud_placement_group.dev.id

  ssh_keys = [
    hcloud_ssh_key.bken.id,
    hcloud_ssh_key.rusty.id,
  ]

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  network {
    alias_ips  = []
    network_id = hcloud_network.main.id
  }

  labels = {
    "environment" : "development"
  }

  depends_on = [
    hcloud_network_subnet.range_1
  ]
}

# resource "hcloud_volume" "dev" {
#   name     = "dev"
#   size     = 50
#   location = "ash"
#   format   = "ext4"
# }

# resource "hcloud_volume_attachment" "dev" {
#   volume_id = hcloud_volume.dev.id
#   server_id = hcloud_server.dev.id
#   automount = true
# }
