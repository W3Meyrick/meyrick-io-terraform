aws_region  = "eu-west-1"
key_name = "id_rsa"
domain_name = "meyrick"

vpc_cidr    = "192.168.100.0/24"
cidrs       = {
  public1 = "192.168.100.0/27"
  public2 = "192.168.100.32/27"
  private1 = "192.168.100.64/27"
  private2 = "192.168.100.96/27"
  rds1 = "192.168.100.128/27"
  rds2 = "192.168.100.160/27"
  rds3 = "192.168.100.192/27"
  spare1 = "192.168.100.224/27"
}
localip   = "151.226.200.236/32"

webdb_instance_type = "t2.micro"
webdb_ami = "ami-70edb016"

delegation_set = "N3SLZFK3V59WGF"
