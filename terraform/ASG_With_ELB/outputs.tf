output "elb_dns_name" {
  value = "${aws_elb.my_ELB.dns_name}"
}
