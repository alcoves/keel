variable "DIGITALOCEAN_TOKEN" {
  type = string
}

terraform {
  required_version = "0.14.7"
  backend "s3" {}

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.5.1"
    }
  }
}

provider "digitalocean" {
  token = var.DIGITALOCEAN_TOKEN
}
