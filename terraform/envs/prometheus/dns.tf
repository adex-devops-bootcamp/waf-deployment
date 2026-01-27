resource "aws_route53_record" "prometheus" {
  zone_id = data.aws_route53_zone.dns.zone_id
  name    = "promethus.tekbay.click"   
  type    = "A"
  ttl     = 300
  records = [module.ec2.public_ip]

  lifecycle {
    prevent_destroy = true
  }
}
