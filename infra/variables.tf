variable "bucket_name" {
  type        = string
  description = "Remote state bucket name"
}

variable "name" {
  type        = string
  description = "Tag name"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "vpc_cidr" {
  type        = string
  description = "Public Subnet CIDR values"
}

variable "vpc_name" {
  type        = string
  description = "DevOps Project 1 VPC 1"
}

variable "cidr_public_subnet" {
  type        = list(string)
  description = "Public Subnet CIDR values"
}

variable "cidr_private_subnet" {
  type        = list(string)
  description = "Private Subnet CIDR values"
}

variable "af_availability_zone" {
  type        = list(string)
  description = "Availability Zones"
}

variable "public_key" {
  type        = string
  description = "DevOps Project 1 Public key for EC2 instance"
}

variable "ec2_ami_id" {
  type        = string
  description = "DevOps Project 1 AMI Id for EC2 instance"
}

variable "subnet_groups" {
  description = "List of subnet IDs for the RDS DB subnet group"
  type        = list(string)
}

/*variable "ec2_user_data_install_node" {
  type = string
  description = "Script for installing the Apache2"
}
variable "domain_name" {
  type = string
  description = "Name of the domain"
}*/


variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default = "t3.micro"
}

variable "db_name" {
  description = "The name of the RDS database"
  type        = string
}

variable "db_username" {
  description = "The username for the RDS database"
  type        = string
}

variable "db_password" {
  description = "The password for the RDS database"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "The instance class for the RDS database"
  type        = string
  default = "db.t3.micro"
}

variable "private_key_path" {
  description = "Path to the private key file used for SSH access"
  type        = string
}

