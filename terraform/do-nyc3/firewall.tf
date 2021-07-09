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

resource "digitalocean_firewall" "postgres" {
  name = "postgres"
  tags = ["postgres"]

  # Disable public access to the db
  inbound_rule {
    protocol         = "tcp"
    port_range       = "5432"
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

resource "digitalocean_firewall" "app" {
  name = "app"
  tags = ["app"]

  # Fabio UI
  # inbound_rule {
  #   protocol         = "tcp"
  #   port_range       = "9998"
  #   source_addresses = ["0.0.0.0/0", "::/0"]
  # }

  inbound_rule {
    protocol   = "tcp"
    port_range = "80"
    source_addresses = [
      "173.245.48.0/20",
      "103.21.244.0/22",
      "103.22.200.0/22",
      "103.31.4.0/22",
      "141.101.64.0/18",
      "108.162.192.0/18",
      "190.93.240.0/20",
      "188.114.96.0/20",
      "197.234.240.0/22",
      "198.41.128.0/17",
      "162.158.0.0/15",
      "104.16.0.0/12",
      "172.64.0.0/13",
      "131.0.72.0/22",
      "2400:cb00::/32",
      "2606:4700::/32",
      "2803:f800::/32",
      "2405:b500::/32",
      "2405:8100::/32",
      "2a06:98c0::/29",
      "2c0f:f248::/32",
    ]
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