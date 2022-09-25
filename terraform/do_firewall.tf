resource "digitalocean_firewall" "ssh" {
  name = "ssh"
  tags = ["ssh"]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "all"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "all"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "digitalocean_firewall" "vpc" {
  name = "vpc"
  tags = ["vpc"]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "all"
    source_addresses = [local.nyc3_ip_range]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "all"
    source_addresses = [local.nyc3_ip_range]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "all"
    destination_addresses = [local.nyc3_ip_range]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "all"
    destination_addresses = [local.nyc3_ip_range]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = [local.nyc3_ip_range]
  }
}

resource "digitalocean_firewall" "all" {
  name = "all"
  tags = ["all"]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "all"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "all"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "all"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "all"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
