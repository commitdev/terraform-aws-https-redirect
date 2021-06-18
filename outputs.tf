output "certificate_arn" {
  description = "The ARN of the created or used certificate"
  value       = var.existing_cert_arn == "" ? module.cert[0].certificate_arn : var.existing_cert_arn
}

output "cloudfront_distribution_arn" {
  description = "The ARN of the created cloudfront distribution"
  value       = aws_cloudfront_distribution.cdn.arn
}

output "s3_bucket_arn" {
  description = "The ARN of the created S3 bucket"
  value       = aws_s3_bucket.redirect.arn
}
