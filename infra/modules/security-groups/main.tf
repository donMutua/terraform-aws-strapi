variable "ec2_sg_name" {}
variable "vpc_id" {}
variable "public_subnet_cidr_block" {}
variable "ec2_sg_name_for_strapi_api" {}


output "ec2_sg_ssh_http_id" {
    value = aws_security_group.ec2_sg_ssh_http.id
}


output "rds_postgress_sg_id" {
    value = aws_security_group.rds_postgress_sg.id
}

output "ec2_sg_name_for_strapi_api" {
    value = aws_security_group.ec2_sg_strapi_api.id

}


resource "aws_security_group" "ec2_sg_ssh_http" {
    name        = var.ec2_sg_name
    description  = "Enable the port 22(SSH) and 80(HTTP) for EC2"
  vpc_id = var.vpc_id

  # ssh for terraform remote exec
  ingress {
    description = "Allow remote SSH from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  # enable http
  ingress {
    description = "Allow HTTP request from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  # enable http
  ingress {
    description = "Allow HTTP request from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }

  #Outgoing request
  egress {
    description = "Allow outgoing request"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Security Groups to allow SSH(22) and HTTP(80)"
  }
}


#Security Group for RDS using Postgres
resource "aws_security_group" "rds_postgress_sg" {
    name        = "rds_postgress_sg"
    description = "Allow inbound access to RDS"
    vpc_id = var.vpc_id

    ingress {
        from_port       = 5432
        to_port         = 5432
        protocol        = "tcp"
        cidr_blocks = var.public_subnet_cidr_block
    }
}

#Security Group for Strapi API
resource "aws_security_group" "ec2_sg_strapi_api" {
    name        = var.ec2_sg_name_for_strapi_api
    description = "Allow inbound access to Strapi API"
    vpc_id = var.vpc_id

    ingress {
        description = "Allow traffic on port 1337 from anywhere"
        from_port       = 1337
        to_port         = 1337
        protocol        = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}