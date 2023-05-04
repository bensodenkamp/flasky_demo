resource "aws_route53_zone" "flasky_zone" {
  name = var.domain
}

resource "aws_route53_record" "flasky_nameservers" {
  allow_overwrite = true
  name            = var.domain
  ttl             = 3600
  type            = "NS"
  zone_id         = aws_route53_zone.flasky_zone.zone_id

  records = aws_route53_zone.flasky_zone.name_servers
}

resource "aws_route53_record" "flasky_cert_validation" {
  allow_overwrite = true
  name            = var.cert_validation_resource_record_name
  records         = var.cert_validation_resource_records
  type            = var.cert_validation_resource_record_type
  zone_id  = aws_route53_zone.flasky_zone.id
  ttl      = 5
}

# This tells terraform to cause the route53 validation to happen
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = var.cert_arn
  validation_record_fqdns = [ aws_route53_record.flasky_cert_validation.fqdn ]
}

# Standard route53 DNS record for "flasky" pointing to an ALB
resource "aws_route53_record" "flasky_a_record" {
  zone_id = aws_route53_zone.flasky_zone.zone_id
  name    = "${aws_route53_zone.flasky_zone.name}"
  type    = "A"
  alias {
    name                   = var.lb_dns_name
    zone_id                = var.lb_zone_id
    evaluate_target_health = false
  }
}