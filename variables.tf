variable "zone_name" {
  description = "Domain name of the Route53 hosted zone"
  type        = string
}

variable "domain_name" {
  description = "Domain to provide the redirect including subdomain if applicable"
  type        = string
}

variable "domain_aliases" {
  description = "Alternative names (aliases) to allow"
  type        = list(string)
  default     = []
}

variable "redirect_target_url" {
  description = "Redirect target - should be a full URL. If http:// or https:// is excluded, the scheme of the request will be used"
  type        = string
}

variable "existing_cert_arn" {
  description = "Provide a ACM certificate ARN if you don't want a new one to be created - must be in the us-east-1 region"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to created resources"
  type        = map(string)
  default     = {}
}
