resource "hcloud_server" "leaders" {
  count                      = local.server_counts.leaders
  name                       = "leader-${count.index}"
  keep_disk                  = true
  backups                    = false
  delete_protection          = false
  rebuild_protection         = false
  allow_deprecated_images    = false
  ignore_remote_firewall_ids = false
  location                   = "ash"
  server_type                = "cpx11"
  image                      = "ubuntu-22.04"
  placement_group_id         = hcloud_placement_group.production.id

  firewall_ids = [
    hcloud_firewall.ssh.id,
    hcloud_firewall.nomad.id,
    hcloud_firewall.consul.id
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

  provisioner "local-exec" {
    when    = destroy
    command = "echo 'Destroy-time provisioner'"
  }

  labels = {
    "environment" = "production"
  }
}

resource "hcloud_server_network" "leaders" {
  alias_ips  = []
  count      = local.server_counts.leaders
  network_id = hcloud_network.main.id
  ip         = "10.0.1.${count.index + 1}"
  server_id  = hcloud_server.leaders[count.index].id
}

resource "null_resource" "leaders" {
  count = local.server_counts.leaders > 1 ? 1 : 0

  triggers = {
    instance_ids = join(",", hcloud_server.leaders.*.id)
  }

  depends_on = [
    hcloud_server_network.leaders
  ]

  provisioner "local-exec" {
    command = join(" ", [
      "../scripts/provision.sh",
      "leaders",
      "${join(",", hcloud_server.leaders[*].ipv4_address)}", # Public IPV4
      "${join(",", hcloud_server_network.leaders[*].ip)}",   # Private IPV4: Retry join leaders
    ])
  }
}
