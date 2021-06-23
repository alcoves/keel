terraform {
  required_version = "1.0.0"
  backend "s3" {
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    region                      = "us-east-1"
    bucket                      = "bken-tf-state"
    endpoint                    = "nyc3.digitaloceanspaces.com"
    key                         = "keel/terraform/do-nyc3/terraform.tfstate"
  }

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.DIGITALOCEAN_TOKEN
}

resource "digitalocean_ssh_key" "bken" {
  name       = "bken"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCPj4RgmqTmors29vS1ITAjXMwvKS/7bodrKjR4d8HEAJLvuLNCWoM0xF6Ugpa19naB7lcn71ARB9B7kenpkV0RXWSAgtWmqsU2GcO4kf4yjSujkUSG+vy/mJbhLHUrcTjnils22bfO48cG8QSOQU8wcqemmu9q3mHfJdtW7wRaKEAiVh2vuDWoggGRPbj3z07tBZhVWVp6JYUTfooNUbGCW4yP3GGxuoySiXfqGsQry4l/i9/4fiUWW7nHW8Z7oKzqyYZuYMvOu/eQLLrg7CUTnm7bWHVIM0uyNweS6UHpmxqM9TI3tY9aT88WiFwdjwuWrHeVz2Sh1PFyw+FdZahd"
}

resource "digitalocean_ssh_key" "rusty" {
  name       = "rusty"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII1d9wv0YoUBs5wBL2MgD80fX1cLxnGBL3pWkAiQ5C9C rusty"
}
