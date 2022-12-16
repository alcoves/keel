terraform {
  required_version = "1.3.0"

  backend "s3" {
    skip_credentials_validation = true
    skip_region_validation      = true
    region                      = "us-east-005"
    bucket                      = "bken-tf-state"
    key                         = "keel/terraform/terraform.tfstate"
    endpoint                    = "https://s3.us-east-005.backblazeb2.com"
  }

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.35.2"
    }

    b2 = {
      source  = "Backblaze/b2"
      version = "0.8.1"
    }
  }
}

provider "hcloud" {
  token = var.HETZNER_API_KEY
}

provider "b2" {
  application_key_id = var.B2_ACCESS_KEY_ID
  application_key    = var.B2_SECRET_ACCESS_KEY
  endpoint           = "https://s3.us-east-005.backblazeb2.com"
}

provider "nomad" {
  address = "http://5.161.138.53:4646"
}
