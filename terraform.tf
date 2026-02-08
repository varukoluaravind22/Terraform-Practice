terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.awsregion
}


resource "aws_vpc" "LMS" {
  cidr_block       = var.vpc-cidr-block
  instance_tenancy = "default"

  tags = {
    Name = var.vpc-name
  }
}