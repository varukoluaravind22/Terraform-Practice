variable "aws_region" {
  type = string
  description = "Enter the region of aws"
}
variable "access_key" {
  type = string
  description = "Enter access key"
}
variable "secret_key" {
  type = string
  description = "Enter secret key"
}
variable "vpc_cidr" {
  type = string
  description = "Enter Vpc cidr block"
}
variable "vpc_name" {
  type = string
  description = "Enter vpc name"
}
variable "public_vpc_cidr_1" {
  type = string
  description = "Enter the public subnet 1 ip range"
}
variable "public_availability_zone_1"{
  type = string
  description = "Enter the availability zone for public subnet 1"
}
variable "public_availability_zone_2"{
  type = string
  description = "Enter the availability zone for public subnet 2"
}
variable "private_availability_zone_1"{
  type = string
  description = "Enter the availability zone for private subnet 1"
}
variable "private_availability_zone_2"{
  type = string
  description = "Enter the availability zone for private subnet 2"
}
variable "public_vpc_cidr_2" {
  type = string
  description = "enter the public subnet 2 range"
}
variable "map_on_public_ip" {
  type = bool
  description = "Enter the bool value true or false"
}
variable "private_vpc_cidr_1" {
  type = string
  description = "Enter private subnet ip range"
}
variable "private_vpc_cidr_2" {
  type = string
  description = "Enter private subnet ip range"
}
variable "internet_gateway_ip" {
  type = string
  description = "Enter the ip for the gateway"
}

variable "instance_type" {
  type = string
  description = "Enter the instance type"
}
variable "ingress_pub_ports" {
  type = list(number)
  description = "Enter the list of ports for security group"
}
variable "ingress_pvt_ports"{
  type = list(number)
  description = "Enter the list of ports for security group"
}