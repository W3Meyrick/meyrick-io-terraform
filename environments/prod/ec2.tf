#web and database server

resource "aws_instance" "wp_webdb" {
  instance_type = "${var.webdb_instance_type}"
  ami           = "${var.webdb_ami}"

  tags {
    Name = "wp_webdb"
  }

  key_name               = "${aws_key_pair.wp_auth.id}"
  vpc_security_group_ids = ["${aws_security_group.wp_public_sg.id}"]
  iam_instance_profile   = "${aws_iam_instance_profile.s3_access_profile.id}"
  subnet_id              = "${aws_subnet.wp_public1_subnet.id}"

  provisioner "local-exec" {
    command = <<EOD
cat <<EOF > aws_hosts 
[webdb] 
${aws_instance.wp_webdb.public_ip} 
[webdb:vars] 
domain=${var.domain_name} 
EOF
EOD
  }

   provisioner "local-exec" {
     command = "aws ec2 wait instance-status-ok --instance-ids ${aws_instance.wp_webdb.id} && ansible-playbook -i aws_hosts webdb.yml --key-file ~/.ssh/wp_key/id_rsa"
   }
}
