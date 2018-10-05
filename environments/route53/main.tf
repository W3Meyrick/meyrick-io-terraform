#---------Route53-------------

#primary zone

resource "aws_route53_zone" "primary" {
  name              = "${var.domain_name}.net"
  delegation_set_id = "${var.delegation_set}"
}

resource "aws_route53_record" "mx" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "${aws_route53_zone.primary.name}"
  type    = "MX"
  ttl     = "3600"

  records = [
    "10 ASPMX.L.GOOGLE.COM",
    "20 ALT1.ASPMX.L.GOOGLE.COM",
    "20 ALT2.ASPMX.L.GOOGLE.COM",
    "30 ALT3.ASPMX.L.GOOGLE.COM",
    "40 ALT4.ASPMX.L.GOOGLE.COM",
  ]
}

#Google Apps

variable "gsuite" {
  default = ["mail", "calendar", "docs"]
}

resource "aws_route53_record" "gsuite" {
  count   = "${length(var.gsuite)}"
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "${element(var.gsuite, count.index)}"
  type    = "CNAME"
  records = ["ghs.google.com"]
  ttl     = "300"
}

#Default

resource "aws_route53_record" "default" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "${var.domain_name}.net"
  type    = "A"
  ttl     = "300"
  records = ["${data.aws_instance.wp_webdb.public_ip}"]
}

#www 

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "www.${var.domain_name}.net"
  type    = "A"
  ttl     = "300"
  records = ["${data.aws_instance.wp_webdb.public_ip}"]
}


resource "aws_route53_zone" "secondary" {
  name              = "meyrick.io"
  delegation_set_id = "${var.delegation_set}"
}

resource "aws_route53_record" "txt-meyrick-io" {
    zone_id = "${aws_route53_zone.secondary.id}"
    name    = "@"
    type    = "TXT"
    records = ["MS=ms29044491"]
    ttl     = "3600"
}