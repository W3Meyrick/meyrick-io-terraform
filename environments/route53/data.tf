data "aws_ssm_parameter" "route53-delegation-set" {
  name = "route53-delegation-set"
}

data "aws_instance" "wp_webdb" {
  instance_tags {
    Name = "wp_webdb"
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}
