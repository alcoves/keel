resource "digitalocean_spaces_bucket" "bken_tfstate" {
  name          = "bken-tfstate"
  region        = "nyc3"
  acl           = "private"
  force_destroy = false
}

resource "digitalocean_spaces_bucket" "cdn_bken_io" {
  name          = "cdn.bken.io"
  region        = "nyc3"
  acl           = "private"
  force_destroy = false
}
