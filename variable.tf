
variable "awsregion" {
  type=string
  description="This is Aws Region"
  default = "ap-south-1"
}

variable "vpc-cidr-block" {
    type= string 
    description = "This is main vpc cidr block"

    validation {
      condition = can(cidrhost(var.vpc-cidr-block,0))
      error_message = "must be valid cidr"
    }
}
variable "vpc-name" {
  type= string 
  description = "Name of the VPC"
}
