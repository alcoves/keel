resource "digitalocean_droplet" "db" {
  name       = "db"
  backups    = true
  monitoring = true
  region     = "nyc3"
  size       = "s-1vcpu-1gb"
  image      = "ubuntu-20-04-x64"

  tags = [
    "vpc",
    "ssh",
    "postgres",
  ]
}
