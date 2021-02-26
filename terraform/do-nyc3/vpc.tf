locals {
  nyc1_ip_range = "10.136.0.0/16"
  nyc3_ip_range = "10.132.0.0/16"
}

resource "digitalocean_vpc" "nyc1" {
  region   = "nyc1"
  name     = "bken.nyc1"
  ip_range = local.nyc1_ip_range
}

resource "digitalocean_vpc" "nyc3" {
  region   = "nyc3"
  name     = "bken.nyc3"
  ip_range = local.nyc3_ip_range
}
