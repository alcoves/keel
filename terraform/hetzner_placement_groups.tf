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
