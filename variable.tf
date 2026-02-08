
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

variable "vpc_name" {
  type= string 
  description = "Name of the VPC"
}

