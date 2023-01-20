resource "hcloud_placement_group" "development" {
  name = "development"
  type = "spread"

  labels = {
    environment = "development"
  }
}

resource "hcloud_placement_group" "production" {
  name = "production"
  type = "spread"

  labels = {
    environment = "production"
  }
}

resource "hcloud_placement_group" "production_a" {
  name = "production_a"
  type = "spread"

  labels = {
    environment = "production_a"
  }
}

resource "hcloud_placement_group" "production_b" {
  name = "production_b"
  type = "spread"

  labels = {
    environment = "production"
  }
}

resource "hcloud_placement_group" "production_c" {
  name = "production_c"
  type = "spread"

  labels = {
    environment = "production"
  }
}

resource "hcloud_placement_group" "production_d" {
  name = "production_d"
  type = "spread"

  labels = {
    environment = "production"
  }
}

resource "hcloud_placement_group" "production_e" {
  name = "production_e"
  type = "spread"

  labels = {
    environment = "production"
  }
}
