
variable "awsregion" {
  type=string
  description="This is Aws Region"
  default = "ap-south-1"
}

variable "awsaccess-key" {
  type = string
  description = "Enter access key value"
}

variable "awssecret-key" {
  type = string
  description = "Enter secret key value"
}

variable "vpc_cidr_block" {
    type= string 
    description = "This is main vpc cidr block"

    validation {
      condition = can(cidrhost(var.vpc_cidr_block,0))
      error_message = "must be valid cidr"
    }
}
variable "public_ip_on_launch" {
  type = bool
  description = "Turn on ipv4 to public"
}
variable "vpc_name" {
  type= string 
  description = "Name of the VPC"
}

variable "vpc_pub_subnet_cidr_block-1" {
  type = string 
  description = "This is Public subnet of LMS"

  validation {
    condition = can(cidrhost(var.vpc_pub_subnet_cidr_block-1,0)) && endswith(var.vpc_pub_subnet_cidr_block-1, "/24")
    error_message = "Must be valid cidr"
  }
}
variable "vpc_pub_sub_name-1" {
  type = string
  description = "Name of the public lms subnet"
}

variable "vpc_pub_subnet_cidr_block-2" {
  type = string
  description = "LMS public subnet 2"

  validation {
    condition = can(cidrhost(var.vpc_pub_subnet_cidr_block-2,0))&& endswith(var.vpc_pub_subnet_cidr_block-2, "/24")
    error_message = "Must be valid cidr"
  }
}
variable "vpc_pub_sub_name-2" {
  type=string
  description = "LMS public subnet 2"
}
variable "vpc_pvt_subnet_cidr_block" {
  type = string
  description = "LMS Private subnet"

  validation {
    condition = can(cidrhost(var.vpc_pvt_subnet_cidr_block,0))&& endswith(var.vpc_pvt_subnet_cidr_block, "/24")
    error_message = "Must be valid cidr"
  }
}
variable "vpc_pvt_sub_name" {
  type = string
  description = "name of LMS pvt subnet"
}
variable "internet_gateway_name" {
  type = string
  description = "Name of internet gateway"
}