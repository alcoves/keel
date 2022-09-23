resource "hcloud_network" "main" {
  name     = "main"
  ip_range = local.heztner_network_range
}

resource "hcloud_network_subnet" "range_1" {
  network_id   = hcloud_network.main.id
  type         = "cloud"
  network_zone = "us-east"
  ip_range     = local.heztner_subnet_1_range
}

resource "hcloud_network_subnet" "range_2" {
  network_id   = hcloud_network.main.id
  type         = "cloud"
  network_zone = "us-east"
  ip_range     = local.heztner_subnet_2_range
}

resource "hcloud_network_subnet" "range_3" {
  network_id   = hcloud_network.main.id
  type         = "cloud"
  network_zone = "us-east"
  ip_range     = local.heztner_subnet_3_range
}
