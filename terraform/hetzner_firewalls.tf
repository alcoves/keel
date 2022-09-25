resource "hcloud_firewall" "ssh" {
  name = "ssh"
  rule {
    direction = "in"
    protocol  = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

resource "hcloud_firewall" "nomad" {
  name = "nomad"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "4646"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}

resource "hcloud_firewall" "consul" {
  name = "consul"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "8500"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}

resource "hcloud_firewall" "fabio" {
  name = "fabio"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "9998"
    source_ips = ["${hcloud_load_balancer.main.ipv4}/32"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "9999"
    source_ips = ["${hcloud_load_balancer.main.ipv4}/32"]
  }
}
