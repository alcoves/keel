locals {
  nomad_config_path  = "/root/nomad.hcl"
  consul_config_path = "/root/consul.hcl"
}

data "template_file" "consul-service" {
  template = file("${path.module}/config/consul.service")
  vars = {
    config_path = local.consul_config_path
  }
}

data "template_file" "nomad-service" {
  template = file("${path.module}/config/nomad.service")
  vars = {
    config_path = local.nomad_config_path
  }
}

data "template_file" "consul-server" {
  template = file("${path.module}/config/leader/consul.hcl")
}

data "template_file" "nomad-server" {
  template = file("${path.module}/config/leader/nomad.hcl")
}

data "template_file" "consul-client" {
  template = file("${path.module}/config/worker/consul.hcl")
  vars = {
    leader_node_private_ip = "10.132.0.2"
  }
}

data "template_file" "nomad-client" {
  template = file("${path.module}/config/worker/nomad.hcl")
}


data "template_file" "provision-leader" {
  template = file("${path.module}/config/leader/provision.sh")
  vars = {
    NOMAD_VERSION  = "1.0.3"
    CONSUL_VERSION = "1.9.3"
  }
}

data "template_file" "provision-worker" {
  template = file("${path.module}/config/worker/provision.sh")
  vars = {
    NOMAD_VERSION  = "1.0.3"
    CONSUL_VERSION = "1.9.3"
  }
}

resource "digitalocean_droplet" "db" {
  name               = "db"
  backups            = true
  monitoring         = true
  private_networking = true
  region             = "nyc3"
  size               = "s-1vcpu-1gb"
  image              = "ubuntu-20-04-x64"
  vpc_uuid           = digitalocean_vpc.nyc3.id
  tags               = ["vpc", "ssh", "postgres"]
  ssh_keys           = [digitalocean_ssh_key.rusty.id]
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
  tags               = ["vpc", "ssh", "leader"]
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
    private_key = file("/home/brendan/.ssh/bken.pem")
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
      "/root/provision.sh",
    ]
  }
}

resource "digitalocean_droplet" "workers" {
  count              = 1
  backups            = true
  monitoring         = true
  private_networking = true
  region             = "nyc3"
  image              = "ubuntu-20-04-x64"
  size               = "s-1vcpu-1gb-intel"
  tags               = ["vpc", "ssh", "worker"]
  name               = "worker-${count.index + 1}"

  ssh_keys = [
    digitalocean_ssh_key.bken.id,
    digitalocean_ssh_key.rusty.id
  ]

  connection {
    timeout     = "2m"
    type        = "ssh"
    user        = "root"
    host        = self.ipv4_address
    private_key = file("/home/brendan/.ssh/bken.pem")
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