locals {
  s3_origin_id = "react-terraform-origin"
  api_origin_id = "api-alb"
}
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "react-terraform-origin"
}

resource "aws_cloudfront_distribution" "cf_distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "react-terraform"
  default_root_object = "index.html"
  origin {
    domain_name = aws_s3_bucket.react-tf-bucket.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }


  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE", "IN", "IR"]
    }
  }

  tags = {
    Environment = "development"
    Name        = "my-tag"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

output "cloudfront_dns" {
  value = aws_cloudfront_distribution.cf_distribution.domain_name
}