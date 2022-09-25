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

  network {
    alias_ips  = []
    network_id = hcloud_network.main.id
    ip         = "10.0.1.${count.index + 1}"
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
    command = count.index == 0 ? "../scripts/provision-leader-master.sh ${self.ipv4_address}" : "../scripts/provision-leader.sh 10.0.1.1 ${self.ipv4_address}"
  }

  provisioner "local-exec" {
    when = destroy
    command = join(" ", [
      "../scripts/deprovision.sh",
      self.ipv4_address
    ])
  }

  labels = {
    "environment" = "production"
  }
}
