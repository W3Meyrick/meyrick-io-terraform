variable "aws_region" {}
data "aws_availability_zones" "available" {}
variable "vpc_cidr" {}

variable "cidrs" {
  type = "map"
}

variable "domain_name" {}
variable "webdb_instance_type" {}
variable "webdb_ami" {}
variable "key_name" {}
