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

# Required so we don't run into the problem where terraform can't plan because it depends on resources that haven't been created yet
variable "use_existing_cert" {
  description = "Set to true to use an existing cert"
  type        = bool
  default     = false
}
variable "existing_cert_arn" {
  description = "The ARN of an ACM cert that already exists - must be in the us-east-1 region"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to created resources"
  type        = map(string)
  default     = {}
}
