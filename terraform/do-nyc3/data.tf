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
    consul_acl_token       = var.CONSUL_TOKEN
    leader_node_private_ip = digitalocean_droplet.leaders[0].ipv4_address_private
  }
}

data "template_file" "nomad-client" {
  template = file("${path.module}/config/worker/nomad.hcl")
  vars = {
    consul_acl_token = var.CONSUL_TOKEN
  }
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