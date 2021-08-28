resource "digitalocean_droplet" "app_a" {
  count              = 1
  backups            = false
  monitoring         = true
  private_networking = true
  region             = "nyc3"
  image              = "86748542"
  size               = "s-1vcpu-1gb-amd"
  tags               = ["vpc", "ssh", "app"]
  name               = "app-a${count.index + 1}"

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
    content     = data.template_file.consul_worker_config.rendered
    destination = "/root/consul.hcl"
  }

  provisioner "file" {
    content     = data.template_file.nomad_worker_config.rendered
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

resource "digitalocean_droplet" "app_b" {
  count              = 1
  backups            = false
  monitoring         = true
  private_networking = true
  region             = "nyc3"
  image              = "86748542"
  size               = "s-1vcpu-1gb-amd"
  tags               = ["vpc", "ssh", "app"]
  name               = "app-b${count.index + 1}"

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
    content     = data.template_file.consul_worker_config.rendered
    destination = "/root/consul.hcl"
  }

  provisioner "file" {
    content     = data.template_file.nomad_worker_config.rendered
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

resource "digitalocean_droplet" "tidal_a" {
  count              = 1
  backups            = false
  monitoring         = true
  private_networking = true
  region             = "nyc3"
  image              = "86748542"
  size               = "s-4vcpu-8gb-amd"
  tags               = ["vpc", "ssh", "tidal"]
  name               = "tidal-a${count.index + 1}"

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
    content     = data.template_file.consul_worker_config.rendered
    destination = "/root/consul.hcl"
  }

  provisioner "file" {
    content     = data.template_file.nomad_worker_config.rendered
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
