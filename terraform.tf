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
  access_key = var.awsaccess-key
  secret_key = var.awssecret-key
}

resource "aws_vpc" "LMS" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "LMS-PUBLIC-SUBNET-1" {
  vpc_id     = aws_vpc.var.vpc_name.id
  cidr_block = var.vpc_pub_subnet_cidr_block-1

  tags = {
    Name = var.vpc_pub_sub_name-1
  }
}

resource "aws_subnet" "LMS-PUBLIC-SUBNET-2" {
  vpc_id     = aws_vpc.var.vpc_name.id
  cidr_block = var.vpc_pub_subnet_cidr_block-2

  tags = {
    Name = var.vpc_pub_sub_name-2
  }
}
resource "aws_subnet" "LMS-PRIVATE-SUBNET" {
  vpc_id     = aws_vpc.var.vpc_name.id
  cidr_block = var.vpc_pvt_subnet_cidr_block

  tags = {
    Name = var.vpc_pvt_sub_name
  }
}