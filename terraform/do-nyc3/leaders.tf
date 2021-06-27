resource "digitalocean_droplet" "leaders_a" {
  count              = 1
  monitoring         = true
  private_networking = true
  backups            = false
  region             = "nyc3"
  image              = "86748542"
  size               = "s-1vcpu-1gb-amd"
  vpc_uuid           = digitalocean_vpc.nyc3.id
  tags               = ["vpc", "ssh", "leader"]
  name               = "leader-a${count.index + 1}"

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
    content     = data.template_file.consul_service.rendered
    destination = "/etc/systemd/system/consul.service"
  }

  provisioner "file" {
    content     = data.template_file.nomad_service.rendered
    destination = "/etc/systemd/system/nomad.service"
  }

  provisioner "file" {
    content     = data.template_file.consul_leader_config.rendered
    destination = "/root/consul.hcl"
  }

  provisioner "file" {
    content     = data.template_file.nomad_leader_config.rendered
    destination = "/root/nomad.hcl"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo systemctl enable consul.service && sudo systemctl start consul.service",
      "sleep 10",
      "sudo systemctl enable nomad.service && sudo systemctl start nomad.service",
    ]
  }
}

resource "digitalocean_droplet" "leaders_b" {
  count              = 1
  monitoring         = true
  private_networking = true
  backups            = false
  region             = "nyc3"
  image              = "86748542"
  size               = "s-1vcpu-1gb-amd"
  vpc_uuid           = digitalocean_vpc.nyc3.id
  tags               = ["vpc", "ssh", "leader"]
  name               = "leader-b${count.index + 1}"

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
    content     = data.template_file.consul_service.rendered
    destination = "/etc/systemd/system/consul.service"
  }

  provisioner "file" {
    content     = data.template_file.nomad_service.rendered
    destination = "/etc/systemd/system/nomad.service"
  }

  provisioner "file" {
    content     = data.template_file.consul_leader_config.rendered
    destination = "/root/consul.hcl"
  }

  provisioner "file" {
    content     = data.template_file.nomad_leader_config.rendered
    destination = "/root/nomad.hcl"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo systemctl enable consul.service && sudo systemctl start consul.service",
      "sleep 10",
      "sudo systemctl enable nomad.service && sudo systemctl start nomad.service",
    ]
  }
}