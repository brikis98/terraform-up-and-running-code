output "elb_dns_name" {
  value = "${aws_elb.example.dns_name}"
}
