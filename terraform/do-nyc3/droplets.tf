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

  provisioner "remote-exec" {
    inline = [
      "sudo systemctl enable consul-leader.service",
      "sudo systemctl start consul-leader.service",
      "sleep 10",
      "sudo systemctl enable nomad-leader.service",
      "sudo systemctl start nomad-leader.service",
    ]
  }
}

resource "digitalocean_droplet" "leaders_green" {
  count              = 1
  monitoring         = true
  private_networking = true
  backups            = false
  region             = "nyc3"
  image              = "86723390"
  size               = "s-1vcpu-1gb-amd"
  vpc_uuid           = digitalocean_vpc.nyc3.id
  tags               = ["vpc", "ssh", "leader"]
  name               = "leader-green-${count.index + 1}"

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

  provisioner "remote-exec" {
    inline = [
      "sudo systemctl enable consul-leader.service",
      "sudo systemctl start consul-leader.service",
      "sleep 20",
      "sudo systemctl enable nomad-leader.service",
      "sudo systemctl start nomad-leader.service",
    ]
  }
}

resource "digitalocean_droplet" "app_workers_green" {
  count              = 1
  backups            = false
  monitoring         = true
  private_networking = true
  region             = "nyc3"
  image              = "86723390"
  size               = "s-1vcpu-1gb-amd"
  tags               = ["vpc", "ssh", "app"]
  name               = "app-worker-green-${count.index + 1}"

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

  provisioner "remote-exec" {
    inline = [
      "sudo systemctl enable consul-worker.service",
      "sudo systemctl start consul-worker.service",
      "sleep 10",
      "sudo systemctl enable nomad-worker.service",
      "sudo systemctl start nomad-worker.service",
    ]
  }
}

resource "digitalocean_droplet" "app_workers_blue" {
  count              = 1
  backups            = false
  monitoring         = true
  private_networking = true
  region             = "nyc3"
  image              = "86723390"
  size               = "s-1vcpu-1gb-amd"
  tags               = ["vpc", "ssh", "app"]
  name               = "app-worker-blue-${count.index + 1}"

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

  provisioner "remote-exec" {
    inline = [
      "sudo systemctl enable consul-worker.service",
      "sudo systemctl start consul-worker.service",
      "sleep 10",
      "sudo systemctl enable nomad-worker.service",
      "sudo systemctl start nomad-worker.service",
    ]
  }
}
