variable "ami_id" {}
variable "instance_type" {}
variable "tag_name" {}
variable "public_key" {}
variable "subnet_id" {}
variable "sg_enable_ssh_https" {}
variable "enable_public_ip_address" {}
variable "user_data_install_node" {}
variable "ec2_sg_name_for_strapi_api" {}


#Create EC2 instance
resource "aws_instance" "dev_proj_strapi_ec2" {
  ami                    =  var.ami_id
  instance_type          = var.instance_type
  key_name               = var.public_key
  subnet_id              = var.subnet_id
  associate_public_ip_address = var.enable_public_ip_address
  vpc_security_group_ids = [var.sg_enable_ssh_https, var.ec2_sg_name_for_strapi_api]

  user_data = var.user_data_install_node



  metadata_options {
    http_tokens = "required"
    http_endpoint = "enabled"
  }

  tags = {
    Name = var.tag_name
  }
}


resource "aws_key_pair" "dev_proj_key_pair" {
  key_name   = "main-key"
  public_key = var.public_key

}

