module "networking" {
    source = "./modules/networking"
    vpc_cidr = var.vpc_cidr
    vpc_name = var.vpc_name
    cidr_public_subnet = var.cidr_public_subnet
    af_availability_zone = var.af_availability_zone
    cidr_private_subnet = var.cidr_private_subnet
}


module "security_group" {
    source = "./modules/security-groups"
    ec2_sg_name = "SG for EC2 to enable SSH(22) and HTTP(80)"
    vpc_id = module.networking.dev_project_vpc_id
    public_subnet_cidr_block = tolist(module.networking.dev_project_public_subnet_cidr_block)
    ec2_sg_name_for_strapi_api = "SG for Strapi API port 1337"

}

module "ec2" {
    source = "./modules/ec2"
    ami_id = var.ec2_ami_id
    instance_type = var.instance_type
    tag_name = "Ubuntu Linux Ec2"
    public_key = var.public_key
    subnet_id = tolist(module.networking.dev_project_public_subnets[0])
    sg_enable_ssh_https = module.security_group.ec2_sg_ssh_http_id
    enable_public_ip_address = true
    user_data_install_node = templatefile("./template/user_data.sh", {NODE_MAJOR = "20"})
    ec2_sg_name_for_strapi_api = module.security_group.ec2_sg_name_for_strapi_api
}


#rds
module "rds_db_instance" {
    source = "./modules/rds"
    rds_postgress_sg_id = module.security_group.rds_postgress_sg_id
    db_name = var.db_name
    db_username = var.db_username
    db_password = var.db_password
    db_instance_class = var.db_instance_class
    subnet_groups = var.subnet_groups

}


