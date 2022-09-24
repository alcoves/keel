resource "hcloud_server" "app_workers" {
  count                      = local.server_counts.app_workers
  name                       = "app-worker-${count.index}"
  keep_disk                  = true
  backups                    = false
  delete_protection          = false
  rebuild_protection         = false
  allow_deprecated_images    = false
  ignore_remote_firewall_ids = false
  location                   = "ash"
  server_type                = "cpx21"
  image                      = "ubuntu-22.04"
  placement_group_id         = hcloud_placement_group.production.id

  firewall_ids = [
    hcloud_firewall.ssh.id,
  ]

  ssh_keys = [
    hcloud_ssh_key.bken.id,
    hcloud_ssh_key.rusty.id,
  ]

  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }

  connection {
    type        = "ssh"
    user        = "root"
    host        = self.ipv4_address
    private_key = file("~/.ssh/rusty")
  }

  provisioner "remote-exec" {
    script = "../scripts/dependencies.sh"
  }

  labels = {
    "app_worker"  = "true"
    "environment" = "production"
  }

  depends_on = [
    hcloud_server.leaders
  ]
}

resource "hcloud_server_network" "app_workers" {
  alias_ips  = []
  count      = local.server_counts.app_workers
  network_id = hcloud_network.main.id
  server_id  = hcloud_server.app_workers[count.index].id
}

resource "null_resource" "app_workers" {
  count = local.server_counts.app_workers > 1 ? 1 : 0

  triggers = {
    instance_ids = join(",", hcloud_server.app_workers.*.id)
  }

  depends_on = [
    hcloud_server_network.app_workers
  ]

  provisioner "local-exec" {
    command = join(" ", [
      "../scripts/provision.sh",
      "workers",
      "${join(",", hcloud_server.app_workers[*].ipv4_address)}", # Public IPV4
      "${join(",", hcloud_server_network.leaders[*].ip)}",       # Private IPV4: Retry join leaders
    ])
  }
}
