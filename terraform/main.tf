terraform {
  required_version = "1.3.0"
  backend "s3" {
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    region                      = "us-east-1"
    bucket                      = "bken-tfstate"
    endpoint                    = "https://nyc3.digitaloceanspaces.com"
    key                         = "keel/terraform/do-nyc3/terraform.tfstate"
  }

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }

    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.35.2"
    }
  }
}

provider "digitalocean" {
  token             = var.DIGITALOCEAN_TOKEN
  spaces_access_id  = var.SPACES_ACCESS_KEY_ID
  spaces_secret_key = var.SPACES_SECRET_ACCESS_KEY
}

provider "hcloud" {
  token = var.HETZNER_API_KEY
}

provider "nomad" {
  address = "http://5.161.138.53:4646"
}
