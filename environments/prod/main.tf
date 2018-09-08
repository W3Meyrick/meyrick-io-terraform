provider "aws" {
  region = "${var.aws_region}"

  #  profile = "${var.aws_profile}"
}

#key pair

resource "aws_key_pair" "wp_auth" {
  key_name   = "${var.key_name}"
  public_key = "${data.aws_ssm_parameter.ssh_public_key.value}"
}
