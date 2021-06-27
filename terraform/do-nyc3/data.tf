data "template_file" "consul_service" {
  template = file("${path.module}/config/consul.service")
}

data "template_file" "consul_leader_config" {
  template = file("${path.module}/config/consul_leader.hcl")
  vars = {
    LEADER_IP = "10.132.0.2"
  }
}

data "template_file" "consul_worker_config" {
  template = file("${path.module}/config/consul_worker.hcl")
  vars = {
    CONSUL_TOKEN = var.CONSUL_TOKEN
    LEADER_IP    = "10.132.0.2"
  }
}

data "template_file" "nomad_service" {
  template = file("${path.module}/config/nomad.service")
}

data "template_file" "nomad_leader_config" {
  template = file("${path.module}/config/nomad_leader.hcl")
  vars = {
    CONSUL_TOKEN = var.CONSUL_TOKEN
  }
}

data "template_file" "nomad_worker_config" {
  template = file("${path.module}/config/nomad_worker.hcl")
  vars = {
    CONSUL_TOKEN = var.CONSUL_TOKEN
  }
}