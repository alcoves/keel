variable "DOCO_API_TOKEN" {
  type = string
}

source "digitalocean" "base" {
  region       = "nyc3"
  ssh_username = "root"
  size         = "s-1vcpu-1gb"
  image        = "ubuntu-20-04-x64"
  api_token    = var.DOCO_API_TOKEN
}

build {
  sources = ["source.digitalocean.base"]
  provisioner "shell" {
    script = "./init.sh"
  }
}