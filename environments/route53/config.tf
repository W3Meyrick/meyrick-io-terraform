terraform {
  required_version = ">= 0.10.5"

  backend "s3" {
    bucket  = "${var.config-bucket-name}"
    key     = "${var.environment}/terraform.tfstate"
    region  = "${var.region}"
    encrypt = true
  }
}

data "terraform_remote_state" "default" {
  backend = "s3"

  config {
    bucket  = "${var.config-bucket-name}"
    key     = "${var.environment}/terraform.tfstate"
    region  = "${var.region}"
    encrypt = true
  }
}
