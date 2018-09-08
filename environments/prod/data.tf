data "aws_ssm_parameter" "mysql_dbuser" {
  name = "mysql_dbuser"
}

data "aws_ssm_parameter" "mysql_rootpass" {
  name = "mysql_rootpass"
}

data "aws_ssm_parameter" "mysql_dbname" {
  name = "mysql_dbname"
}

data "aws_ssm_parameter" "mysql_dbpass" {
  name = "mysql_dbpass"
}

data "aws_ssm_parameter" "ssh_public_key" {
  name = "ssh_public_key"
}
