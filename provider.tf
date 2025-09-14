terraform {
  backend "s3" {
    bucket         = "ram-tf-state-bucket1"
    key            = "env/dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "dynamo-lock-table"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}