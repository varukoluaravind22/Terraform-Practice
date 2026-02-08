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
  vpc_id     = aws_vpc.LMS.id
  cidr_block = var.vpc_pub_subnet_cidr_block-1
  map_public_ip_on_launch = var.public_ip_on_launch
  tags = {
    Name = var.vpc_pub_sub_name-1
  }
}

resource "aws_subnet" "LMS-PUBLIC-SUBNET-2" {
  vpc_id     = aws_vpc.LMS.id
  cidr_block = var.vpc_pub_subnet_cidr_block-2
  map_public_ip_on_launch = var.public_ip_on_launch
  tags = {
    Name = var.vpc_pub_sub_name-2
  }
}
resource "aws_subnet" "LMS-PRIVATE-SUBNET" {
  vpc_id     = aws_vpc.LMS.id
  cidr_block = var.vpc_pvt_subnet_cidr_block

  tags = {
    Name = var.vpc_pvt_sub_name
  }
}

resource "aws_internet_gateway" "Gateway" {
  vpc_id = aws_vpc.LMS.id

  tags = {
    Name = var.internet_gateway_name
  }
}
resource "aws_internet_gateway_attachment" "Gateway_attachment" {
  internet_gateway_id = aws_internet_gateway.Gateway.id
  vpc_id              = aws_vpc.LMS.id
}
resource "aws_route_table" "LMS_ROUTE_TABLE" {
  vpc_id = aws_vpc.LMS.id

route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Gateway.id
  }
  tags = {
    Name = "${var.vpc_name}-Route_table"
  }
}