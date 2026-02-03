resource "aws_route53_record" "prometheus" {
  zone_id = data.aws_route53_zone.dns.zone_id
  name    = "elk.tekbay.click"   
  type    = "A"
  ttl     = 60
  records = [module.ec2.public_ip]
}


