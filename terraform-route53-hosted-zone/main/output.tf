output "route53_hosted_zone_details" {
  description = "Route53 Hosted Zone ID and Nameserver"
  value       = "${module.route53_hosted_zone}"
}
