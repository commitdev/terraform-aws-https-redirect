
locals {
  all_domains = concat([var.domain_name], var.domain_aliases)
  origin_id   = "redirect-${var.domain_name}"
}

module "cert" {
  source  = "commitdev/zero/aws//modules/certificate"
  version = "0.1.0"
  count   = var.existing_cert_arn == "" ? 1 : 0

  zone_name         = var.zone_name
  domain_name       = var.domain_name
  alternative_names = var.domain_aliases
}


resource "aws_s3_bucket" "redirect" {
  // Our bucket's name is going to be the same as our site's domain name.
  bucket = var.domain_name
  acl    = "public-read"

  website {
    redirect_all_requests_to = var.redirect_target_url
  }

  tags = var.tags
}

# Create the cloudfront distribution - this is just to add HTTPS which is not supported by S3
resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = aws_s3_bucket.redirect.website_endpoint
    origin_id   = local.origin_id

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }


  enabled         = true
  is_ipv6_enabled = true

  default_cache_behavior {
    target_origin_id       = local.origin_id
    viewer_protocol_policy = "redirect-to-https"
    compress               = false
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  aliases = local.all_domains

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Use our cert
  viewer_certificate {
    acm_certificate_arn      = var.existing_cert_arn == "" ? module.cert[0].certificate_arn : var.existing_cert_arn
    minimum_protocol_version = "TLSv1"
    ssl_support_method       = "sni-only"
  }

  tags = var.tags

  #   depends_on = [module.cert[0].certificate_validation]
}


data "aws_route53_zone" "zone" {
  name = var.zone_name
}

# Domains to point at CF
resource "aws_route53_record" "domains" {
  count = length(local.all_domains)

  zone_id = data.aws_route53_zone.zone.zone_id
  name    = local.all_domains[count.index]
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}
