variable "vpc_cidr" {}
variable "vpc_name" {}
variable "cidr_public_subnet" {}
variable "af_availability_zone" {}
variable "cidr_private_subnet" {}

output "dev_project_vpc_id" {
    value = aws_vpc.dev_project_vpc_af_south.id
}

output "dev_project_public_subnets" {

    value = aws_subnet.dev_project_public_subnets.*.id
}


output "dev_project_private_subnet_ids" {
    value = aws_subnet.dev_project_private_subnets.*.id
}





output "dev_project_public_subnet_cidr_block" {
    value = aws_subnet.dev_project_public_subnets.*.cidr_block
}



#Setup Vpc
resource "aws_vpc" "dev_project_vpc_af_south" {
    cidr_block = var.vpc_cidr

    tags = {
        Name = var.vpc_name
    }

}


#Setup Public Subnet
resource "aws_subnet" "dev_project_public_subnets" {
    count = length(var.cidr_public_subnet)
    vpc_id = aws_vpc.dev_project_vpc_af_south.id
    cidr_block = element(var.cidr_public_subnet, count.index)
    availability_zone = element(var.af_availability_zone, count.index)

    tags = {
        Name = "dev-project-public-subnet-${count.index + 1}"
    }
}


#Setup Private Subnet
resource "aws_subnet" "dev_project_private_subnets" {
    count = length(var.cidr_private_subnet)
    vpc_id = aws_vpc.dev_project_vpc_af_south.id
    cidr_block = element(var.cidr_private_subnet, count.index)
    availability_zone = element(var.af_availability_zone, count.index)

    tags = {
        Name = "dev-project-private-subnet-${count.index + 1}"
    }
}

#Setup Internet Gateway
resource "aws_internet_gateway" "dev_project_internet_gateway" {
    vpc_id = aws_vpc.dev_project_vpc_af_south.id

    tags = {
        Name = "dev-project-igw"
    }
}


#Setup Public Route Table
resource "aws_route_table" "dev_project_public_route_table" {
    vpc_id = aws_vpc.dev_project_vpc_af_south.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.dev_project_internet_gateway.id
        }

    tags = {
        Name = "dev-project-public-route-table"
    }
}

#Setup Public Route Table Association
resource "aws_route_table_association" "dev_project_public_route_table_association" {
    count = length(aws_subnet.dev_project_public_subnets)
    subnet_id      = aws_subnet.dev_project_public_subnets[count.index].id
    route_table_id = aws_route_table.dev_project_public_route_table.id
}

#Setup Private Route Table
resource "aws_route_table" "dev_project_private_route_table" {
    vpc_id = aws_vpc.dev_project_vpc_af_south.id

    tags = {
        Name = "dev-project-private-route-table"
    }
}


#Setup Private Route Table Association
resource "aws_route_table_association" "dev_project_private_route_table_association" {
    count = length(aws_subnet.dev_project_private_subnets)
    subnet_id      = aws_subnet.dev_project_private_subnets[count.index].id
    route_table_id = aws_route_table.dev_project_private_route_table.id
}




