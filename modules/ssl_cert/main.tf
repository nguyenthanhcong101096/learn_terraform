data "aws_route53_zone" "public" {
  name         = var.dns_domain
  private_zone = false
}

# Standard route53 DNS record for "myapp" pointing to an ALB
resource "aws_route53_record" "my_domain" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = data.aws_route53_zone.public.name
  type    = "A"

  alias {
    name                   = var.aws_alb.dns_name
    zone_id                = var.aws_alb.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "my_sub_domain" {
  count   = length(var.request_certificates)
  zone_id = data.aws_route53_zone.public.zone_id
  name    = element(var.request_certificates, count.index)
  type    = "CNAME"

  alias {
    name                   = var.aws_alb.dns_name
    zone_id                = var.aws_alb.zone_id
    evaluate_target_health = false
  }
}

# This creates an SSL certificate
resource "aws_acm_certificate" "certificate" {
  domain_name               = data.aws_route53_zone.public.name
  subject_alternative_names = var.request_certificates
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  count           = (length(var.request_certificates) + 1)
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.certificate.domain_validation_options)[count.index].resource_record_name
  records         = [tolist(aws_acm_certificate.certificate.domain_validation_options)[count.index].resource_record_value]
  type            = tolist(aws_acm_certificate.certificate.domain_validation_options)[count.index].resource_record_type
  zone_id         = data.aws_route53_zone.public.id
  ttl             = 60
}

# This tells terraform to cause the route53 validation to happen
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = aws_acm_certificate.certificate.arn
  validation_record_fqdns = aws_route53_record.cert_validation.*.fqdn
}
