provider "aws" {
  region = "${var.aws_region}"

  #  profile = "${var.aws_profile}"
}

terraform {
  required_version = ">= 0.10.5"

  backend "s3" {
    bucket  = "meyrickblog-tfstate"
    key     = "route53/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}

data "terraform_remote_state" "default" {
  backend = "s3"

  config {
    bucket  = "meyrickblog-tfstate"
    key     = "route53/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}
