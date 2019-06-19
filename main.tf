/**
# Terraform Multi-account Transit Gateway

This script can be used to deploy a datascientist setup on Microsoft Azure. It uses [terraform](https://www.terraform.io/downloads.html) to orchestrate the deployment.

## Prerequisites
  - An AWS account
  - AWS Vault confugured
  - Terraform

## Documentation generation
Documentation should be modified within `main.tf` and generated using [terraform-docs](https://github.com/segmentio/terraform-docs):

```bash
terraform-docs md ./ |sed '$d' >| README.md
```

## License
GPL 3.0 Licensed. See [LICENSE](LICENSE) for full details.
*/

terraform {
  required_version = ">= 0.12"
}

provider "null" {}
provider "template" {}
