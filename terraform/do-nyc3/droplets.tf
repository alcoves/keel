locals {
  nomad_config_path  = "/root/nomad.hcl"
  consul_config_path = "/root/consul.hcl"
}

resource "digitalocean_droplet" "leaders" {
  count              = 1
  monitoring         = true
  private_networking = true
  backups            = false
  region             = "nyc3"
  image              = "ubuntu-20-04-x64"
  size               = "s-1vcpu-1gb-intel"
  vpc_uuid           = digitalocean_vpc.nyc3.id
  tags               = ["vpc", "ssh", "leader", "all"]
  name               = "leader-${count.index + 1}"

  ssh_keys = [
    digitalocean_ssh_key.bken.id,
    digitalocean_ssh_key.rusty.id
  ]

  connection {
    timeout     = "2m"
    type        = "ssh"
    user        = "root"
    host        = self.ipv4_address
    private_key = file("~/.ssh/bken.pem")
  }

  provisioner "file" {
    content     = data.template_file.consul-server.rendered
    destination = local.consul_config_path
  }

  provisioner "file" {
    content     = data.template_file.nomad-server.rendered
    destination = local.nomad_config_path
  }

  provisioner "file" {
    content     = data.template_file.consul-service.rendered
    destination = "/etc/systemd/system/consul.service"
  }

  provisioner "file" {
    content     = data.template_file.nomad-service.rendered
    destination = "/etc/systemd/system/nomad.service"
  }

  provisioner "file" {
    content     = data.template_file.provision-leader.rendered
    destination = "/root/provision.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /root/provision.sh",
      "sed -i .bak 's/1.2.3.4/${self.ipv4_address}/g' ${local.nomad_config_path}",
      "mv .bak ${local.nomad_config_path}",
      "/root/provision.sh",
    ]
  }
}

resource "digitalocean_droplet" "app-workers" {
  count              = 1
  backups            = true
  monitoring         = true
  private_networking = true
  region             = "nyc3"
  image              = "ubuntu-20-04-x64"
  size               = "s-1vcpu-2gb-intel"
  tags               = ["vpc", "ssh", "app"]
  name               = "app-${count.index + 1}"

  ssh_keys = [
    digitalocean_ssh_key.bken.id,
    digitalocean_ssh_key.rusty.id
  ]

  connection {
    timeout     = "2m"
    type        = "ssh"
    user        = "root"
    host        = self.ipv4_address
    private_key = file("~/.ssh/bken.pem")
  }

  provisioner "file" {
    content     = data.template_file.consul-client.rendered
    destination = local.consul_config_path
  }

  provisioner "file" {
    content     = data.template_file.nomad-client.rendered
    destination = local.nomad_config_path
  }

  provisioner "file" {
    content     = data.template_file.consul-service.rendered
    destination = "/etc/systemd/system/consul.service"
  }

  provisioner "file" {
    content     = data.template_file.nomad-service.rendered
    destination = "/etc/systemd/system/nomad.service"
  }

  provisioner "file" {
    content     = data.template_file.provision-worker.rendered
    destination = "/root/provision.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /root/provision.sh",
      "/root/provision.sh",
    ]
  }
}
