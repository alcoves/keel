
resource "digitalocean_droplet" "pier" {
  name       = "pier"
  region     = "nyc3"
  size       = "s-1vcpu-1gb-amd"
  image      = "ubuntu-20-04-x64"
  monitoring = true

  tags = [
    "app",
    "vpc",
    "ssh"
  ]
}

resource "digitalocean_droplet" "reef" {
  name       = "reef"
  region     = "nyc3"
  image      = "ubuntu-20-04-x64"
  size       = "s-1vcpu-1gb-amd"
  monitoring = true

  tags = [
    "app",
    "vpc",
    "ssh"
  ]
}