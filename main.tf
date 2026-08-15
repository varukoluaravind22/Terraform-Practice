terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
    }
  }
}
#provider block for the aws provider
provider "aws" {
  region = var.aws_region

  access_key = var.access_key
  secret_key = var.secret_key
}
resource "aws_vpc" "Entire_arch" {
   cidr_block = var.vpc_cidr
   tags = {
     Name = var.vpc_name
   }
 }
 
 # public subnet ceation for the vpc
resource "aws_subnet" "Entire_pub_subnet-1" {
  vpc_id = aws_vpc.Entire_arch.id
  cidr_block = var.public_vpc_cidr_1
  availability_zone = var.public_availability_zone_1
  map_public_ip_on_launch = var.map_on_public_ip
  tags = {
    Name = "${var.vpc_name}_pub_subnet_1"
  }
}

#below is the private subnet creation for the vpc
resource "aws_subnet" "Entire_pvt_subnet-1" {
  vpc_id = aws_vpc.Entire_arch.id
  cidr_block = var.private_vpc_cidr_1
  availability_zone = var.private_availability_zone_1
  tags ={
    Name= "${var.vpc_name}_pvt_subnet_1"
  }
}
resource "aws_subnet" "Entire_pvt_subnet-2"{
  vpc_id = aws_vpc.Entire_arch.id
  cidr_block = var.private_vpc_cidr_2
  availability_zone = var.private_availability_zone_2
  tags ={
    Name = "${var.vpc_name}_pvt_subnet_2"
  }
}
#creation of internet gateway for the vpc
resource "aws_internet_gateway" "Entire_arch_internet_gateway" {
  vpc_id = aws_vpc.Entire_arch.id
  tags ={
    Name = "${var.vpc_name}_internet_gateway"
  }
}
resource "aws_eip" "Entire_arch_nat_gateway_eip"{
  domain="vpc"
}
resource "aws_nat_gateway" "Entire_arch_nat_gateway"{
  allocation_id= aws_eip.Entire_arch_nat_gateway_eip.id
  subnet_id= aws_subnet.Entire_pub_subnet-1.id
  tags = {
    Name = "${var.vpc_name}_nat_gateway"
  }
}
#public route table creation
resource "aws_route_table" "Entire_arch_public_route_table" {
  vpc_id = aws_vpc.Entire_arch.id
  route  {
    cidr_block = var.internet_gateway_ip
    gateway_id = aws_internet_gateway.Entire_arch_internet_gateway.id
  }
  tags ={
    Name ="${var.vpc_name}_public_route_table"
  }
}

#private route table creation

resource "aws_route_table" "Entire_arch_private_route_table" {
  vpc_id = aws_vpc.Entire_arch.id
  route {
    gateway_id= aws_nat_gateway.Entire_arch_nat_gateway.id
    cidr_block = var.internet_gateway_ip
  }
  tags ={
    Name = "${var.vpc_name}_private_route_table"
  }
}

/**resource "aws_route_table_association" "Entire_arch_pub_rt_association" {
  subnet_id = aws_subnet.Entire_pub_subnet-1.id
  route_table_id = aws_route_table.Entire_arch_public_route_table.id
}
resource "aws_route_table_association" "Entire_arch_pub_rt_association" {
  subnet_id = aws_subnet.Entire_pub_subnet-2.id
  route_table_id = aws_route_table.Entire_arch_public_route_table.id
}**/

# instead of write the single single block mutliple times we can use for_each as shown below for 
#routle table association
#public route table association creation
resource "aws_route_table_association" "Entire_arch_pub_rt_association" {
  for_each = {
    pub1 = aws_subnet.Entire_pub_subnet-1.id
  }
  subnet_id = each.value
  route_table_id = aws_route_table.Entire_arch_public_route_table.id
}

#private route table association creation

resource "aws_route_table_association" "EntireArch_pvt_rt_association"{
  for_each = {
    pvt1 = aws_subnet.Entire_pvt_subnet-1.id
    pvt2 = aws_subnet.Entire_pvt_subnet-2.id
  }
  subnet_id = each.value
  route_table_id =aws_route_table.Entire_arch_private_route_table.id
}

#creation of network acl for the vpc

resource "aws_network_acl" "Entire_arch_nacl" {
  vpc_id = aws_vpc.Entire_arch.id
  ingress {
    protocol = "tcp"
    rule_no = "100"
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = "0"
    to_port = "0"
  }
  egress {
    protocol = "tcp"
    rule_no = "100"
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = "0"
    to_port = "0"
  }
  tags ={
    Name = "${var.vpc_name}_nacl"
  }
}

/**resource "aws_network_acl_association" "Entire_arch_nacl_association" {
  subnet_id = aws_subnet.Entire_pub_subnet-1.id
  network_acl_id = aws_network_acl.Entire_arch_nacl.id
}
resource "aws_network_acl_association" "Entire_arch_nacl_association" {
  subnet_id = aws_subnet.Entire_pub_subnet-2.id
  network_acl_id = aws_network_acl.Entire_arch_nacl.id
}
resource "aws_network_acl_association" "Entire_arch_nacl_association" {
  subnet_id = aws_subnet.Entire_pvt_subnet.id
  network_acl_id = aws_network_acl.Entire_arch_nacl.id
}**/
#instead of write the single single block mutliple times we can use for_each as shown below for nacl association
# NETWORK ACL ASSOCIATION CREATION
resource "aws_network_acl_association" "Entire_arch_nacl_association" {
  for_each = {
    pub1 = aws_subnet.Entire_pub_subnet-1.id
    pvt1 = aws_subnet.Entire_pvt_subnet-1.id
    pvt2 = aws_subnet.Entire_pvt_subnet-2.id
  }
  subnet_id = each.value
  network_acl_id = aws_network_acl.Entire_arch_nacl.id
}

#EKS CLUSTER CREATION

resource "aws_eks_cluster" "Entire_arch_eks_cluster"{
  name = "${var.vpc_name}_eks_cluster"
  access_config {
    authentication_mode = "API"
  }
  role_arn = aws_iam_role.Entire_arch_cluster_role.arn
  version = "1.36"
  vpc_config {
  subnet_ids = [aws_subnet.Entire_pvt_subnet-1.id, aws_subnet.Entire_pvt_subnet-2.id]
  #The EKS API server can be reached from inside your VPC/private network.
#Example: if the above is true then we can use the command in bastion and from there ssh to pvt ec2 and use the command to configure eks aws eks update-kubeconfig --region ap-south-1 --name my-cluster

  endpoint_private_access= true
#The EKS API server can also be reached through a public AWS endpoint
#from the Internet, subject to endpoint access restrictions.
#Example: if the above is true then we can use the command in laptop and be used over internet aws eks update-kubeconfig --region ap-south-1 --name my-cluster

  endpoint_public_access = false
  }
  depends_on = [aws_iam_role_policy_attachment.Entire-arch_eks_cluster_policy]
}

#cluster role creation for the eks cluster creation

resource "aws_iam_role" "Entire_arch_cluster_role"{
  name = "Entire_arch_cluster_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
      Effect = "allow"
      Action = "sts:AssumeRole"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }
    ]
  })
}

#cluster policy attachment to the role for the eks cluster creation

resource "aws_iam_role_policy_attachment" "Entire-arch_eks_cluster_policy"{
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.Entire_arch_cluster_role.name
}


resource "aws_eks_node_group" "Entire_arch_eks_cluster_node_group"{
  cluster_name = aws_eks_cluster.Entire_arch_eks_cluster.name
  node_group_name = "${var.vpc_name}_eks_node_group"
  node_role_arn = aws_iam_role.Entire_arch_node_role.arn
  subnet_ids =[
    aws_subnet.Entire_pvt_subnet-1.id,
    aws_subnet.Entire_pvt_subnet-2.id
  ]
  scaling_config {
    desired_size = 2
    max_size = 5
    min_size = 1
  }
  update_config{
    max_unavailable = 1 
  }
  depends_on = [
    aws_iam_role_policy_attachment.Entire-arch_eks_node_policy
  ]
}
#node  group  role creation for the eks cluster
resource "aws_iam_role" "Entire_arch_node_role"{
  name = "Entire_arch_node_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
     {
      Effect ="allow"
      Action =" sts:AssumeRole"
      Principal = {
        Service = [
          "eks-nodegroup.amazonaws.com"
        ]
      }
     }
    ]
  })
}

#role policy attachment to the role for the eks node creation

resource "aws_iam_role_policy_attachment" "Entire-arch_eks_node_policy"{
  for_each={
    policy1 = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    policy2 = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    policy3 = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    policy4 = "arn:aws:iam::aws:policy/AmazonElasticContainerRegistryPublicReadOnly"
  }
  policy_arn = each.value
  role =aws_iam_role.Entire_arch_node_role.name
}

#ami data source to get the latest ubuntu ami for the instance creation

data "aws_ami" "ubuntu" {
  most_recent = true
  filter{ 
    name = "name"
     values = [ "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }  
  filter{
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

#instance creation

resource "aws_instance" "ubuntu2"{
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.Entire_pvt_subnet-1.id
  security_groups = [aws_security_group.Entire_pvt_arch_security_group.id]
  tags = {
    Name = "${var.vpc_name}_Cluster_pvt_instance"
  }
}

resource "aws_instance" "ubuntu1" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.Entire_pub_subnet-1.id
  security_groups = [aws_security_group.Entire_pub_arch_security_group.id]
  tags ={
    Name = "${var.vpc_name}_Bastion_pub_instance"
  }
}

# security group for the instance
resource "aws_security_group" "Entire_pvt_arch_security_group"{
  vpc_id = aws_vpc.Entire_arch.id
  description = "security group ${var.vpc_name}_pvt_Sg"
  dynamic "ingress"{
  for_each = var.ingress_pvt_ports
  content{
     from_port = ingress.value
     to_port = ingress.value
     protocol = "tcp"
     cidr_blocks = ["${aws_instance.ubuntu1.private_ip}/32"]
     }
  }
  egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["${aws_instance.ubuntu1.private_ip}/32"]
  }
  tags = {
    Name = "${var.vpc_name}_pvt_instance_security_group"
    }
}

resource "aws_security_group" "Entire_pub_arch_security_group" {
  vpc_id = aws_vpc.Entire_arch.id
  description = "security group of ${var.vpc_name}_SG"
  dynamic "ingress" {
    for_each = var.ingress_pub_ports
    content{
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks =["0.0.0.0/0"]
  } 
  tags = {
    Name = "${var.vpc_name}_pub_instance_security_group"
  }
  #instead of writing multiple blocks of ingress we can use the dynamic ingress blocking using for_each loop for multiple ports at sing time.
 /** ingress {
    from_port = 22
    to_port =22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } **/
}