terraform {
  required_version = "~> 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.100"
    }
  }
  backend "s3" {
    bucket         = "rs-school-terraform-state-1"
    key            = "tf-state/rs-school/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "rs-school-terraform-locks-1"
  }
}

provider "aws" {
  region = var.aws_region
}
