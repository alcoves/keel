resource "hcloud_server" "compute_workers" {
  count                      = local.server_counts.compute_workers
  name                       = "compute-worker-cpx31-${count.index}"
  keep_disk                  = true
  backups                    = false
  delete_protection          = false
  rebuild_protection         = false
  allow_deprecated_images    = false
  ignore_remote_firewall_ids = false
  location                   = "ash"
  server_type                = "cpx31"
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


  network {
    alias_ips  = []
    network_id = hcloud_network.main.id
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
    command = join(" ", [
      "../scripts/provision-worker.sh",
      "10.0.1.1", # Private IPV4: Retry join leader
      self.ipv4_address
    ])
  }

  provisioner "remote-exec" {
    when = destroy
    inline = [
      "sudo systemctl stop consul",
      "sudo systemctl stop nomad",
      "sleep 20"
    ]
  }

  provisioner "local-exec" {
    when = destroy
    command = join(" ", [
      "../scripts/deprovision.sh",
      self.ipv4_address,
    ])
  }

  labels = {
    "environment" = "production"
  }

  depends_on = [
    hcloud_server.leaders,
    hcloud_network_subnet.range_1
  ]
}

resource "hcloud_server" "compute_workers_cpx51" {
  count                      = local.server_counts.compute_workers_cpx51
  name                       = "compute-worker-cpx51-${count.index}"
  keep_disk                  = true
  backups                    = false
  delete_protection          = false
  rebuild_protection         = false
  allow_deprecated_images    = false
  ignore_remote_firewall_ids = false
  location                   = "ash"
  server_type                = "cpx51"
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


  network {
    alias_ips  = []
    network_id = hcloud_network.main.id
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
    command = join(" ", [
      "../scripts/provision-worker.sh",
      "10.0.1.1", # Private IPV4: Retry join leader
      self.ipv4_address
    ])
  }

  provisioner "remote-exec" {
    when = destroy
    inline = [
      "sudo systemctl stop consul",
      "sudo systemctl stop nomad",
      "sleep 20"
    ]
  }

  provisioner "local-exec" {
    when = destroy
    command = join(" ", [
      "../scripts/deprovision.sh",
      self.ipv4_address,
    ])
  }

  labels = {
    "environment" = "production"
  }

  depends_on = [
    hcloud_server.leaders,
    hcloud_network_subnet.range_1
  ]
}
