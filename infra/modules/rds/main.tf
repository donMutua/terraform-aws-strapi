
variable "db_instance_class" {}
variable "db_name" {}
variable "db_username" {}
variable "db_password" {}
variable "rds_postgress_sg_id" {}
variable "subnet_groups" {}





#RDS Subnet Group
resource "aws_db_subnet_group" "dev_project_db_subnet_group" {
  name       = "dev_project_db_subnet_group"
 subnet_ids = var.subnet_groups

  tags = {
    Name = "dev_project_db_subnet_group"
  }


}


#RDS Instance

resource "aws_db_instance" "dev_project_rds" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "16"
  instance_class       = var.db_instance_class
  db_name                = var.db_name
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.dev_project_db_subnet_group.name
  vpc_security_group_ids = [var.rds_postgress_sg_id]
  skip_final_snapshot     = true
  apply_immediately       = true
  backup_retention_period = 0
  deletion_protection     = false

  tags = {
    Name = "dev_project_rds"

  }
}