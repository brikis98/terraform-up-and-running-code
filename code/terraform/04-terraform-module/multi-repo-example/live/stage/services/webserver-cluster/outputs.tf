output "elb_dns_name" {
  value = "${module.webserver_cluster.elb_dns_name}"
}
