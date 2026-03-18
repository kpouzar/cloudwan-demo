
####################################################################
# TERRAFORM CONFIG
####################################################################
terraform {
  required_version = "~> 1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.36.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-state-958315857631"
    key     = "cloudwan-demo/terraform.tfstate"
    region  = "eu-central-1"
    use_lockfile = true
    encrypt = false
  }
}

provider "aws" {
  region = var.aws_region1
  alias = "primary"

  default_tags {
    tags = {
      Project     = var.project
      Owner       = var.owner
    }
  }
}

provider "aws" {
  region = var.aws_region2
  alias = "secondary"

  default_tags {
    tags = {
      Project     = var.project
      Owner       = var.owner
    }
  }
}
