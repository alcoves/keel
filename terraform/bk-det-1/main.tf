terraform {
  required_version = "0.14.7"

  backend "s3" {
    skip_credentials_validation = true
    key                         = "bk-det-1"
    region                      = "us-east-2"
    bucket                      = "bken-tfstate"
    endpoint                    = "s3.us-east-2.wasabisys.com"
  }
}
