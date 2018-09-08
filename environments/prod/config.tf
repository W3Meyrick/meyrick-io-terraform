terraform {
  required_version = ">= 0.10.5"

  backend "s3" {
    bucket  = "meyrickblog-tfstate"
    key     = "prod/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}

data "terraform_remote_state" "default" {
  backend = "s3"

  config {
    bucket  = "meyrickblog-tfstate"
    key     = "prod/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}
