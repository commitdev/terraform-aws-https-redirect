# aws-https-redirect

Create a HTTPS redirect using free AWS resources - Cloudfront, S3, ACM, Route53

[![Validation Status](https://github.com/commitdev/terraform-aws-zero/workflows/Validate%20Terraform/badge.svg)](https://github.com/commitdev/terraform-aws-zero/actions)


## Contributing

Full contribution [guidelines are covered here](/.github/CONTRIBUTING.md).

## Doc generation

Code formatting and documentation for variables and outputs is generated using [pre-commit-terraform hooks](https://github.com/antonbabenko/pre-commit-terraform) which uses [terraform-docs](https://github.com/segmentio/terraform-docs).

Follow [these instructions](https://github.com/antonbabenko/pre-commit-terraform#how-to-install) to install pre-commit locally.

And install `terraform-docs` with `go get github.com/segmentio/terraform-docs` or `brew install terraform-docs`.


## Maintainers

Please install (via brew or whatever means) `git-chglog`.

To update the changelog, run `make changelog`
To release a new version, check out the main branch and run `make release`. The new version should be automatically detected by Terraform Registry.

By default these commands will tag or create changelogs for a new 'patch' version. To increment 'minor' or 'major' versions prefix the make command with `SCOPE=minor`.


## Notes

This allows you to do a redirect from a domain to a domain plus a path, which is something that isn't supported just through DNS, as it requires knowledge of HTTP.

For example, foo.test.com -> bar.test.com/baz/

The only requirement is an existing Route53 zone.

The AWS provider must be within region us-east-1 to work properly with cloudfront.
If your provider is already set up in a different region you can create another and provide it explicitly:

```
provider "aws" {
  alias  = "east1"
  region = "us-east-1"
}

module "redirect" {
  source    = "commitdev/aws-https-redirect"
  providers = {
    aws = aws.east1
  }

  ...
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14 |
| aws | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| domain\_aliases | Alternative names (aliases) to allow | `list(string)` | `[]` | no |
| domain\_name | Domain to provide the redirect including subdomain if applicable | `string` | n/a | yes |
| existing\_cert\_arn | The ARN of an ACM cert that already exists - must be in the us-east-1 region | `string` | `""` | no |
| redirect\_target\_url | Redirect target - should be a full URL. If http:// or https:// is excluded, the scheme of the request will be used | `string` | n/a | yes |
| tags | Tags to apply to created resources | `map(string)` | `{}` | no |
| use\_existing\_cert | Set to true to use an existing cert | `bool` | `false` | no |
| zone\_name | Domain name of the Route53 hosted zone | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| certificate\_arn | The ARN of the created or used certificate |
| cloudfront\_distribution\_arn | The ARN of the created cloudfront distribution |
| s3\_bucket\_arn | The ARN of the created S3 bucket |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
