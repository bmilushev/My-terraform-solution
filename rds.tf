# Create a DB subnet group for the RDS instance
resource "aws_db_subnet_group" "my_db_subnet_group" {
  name        = "my-db-subnet-group"
  description = "My DB Subnet Group"
  subnet_ids  = [aws_subnet.subnet_az1_private_1.id, aws_subnet.subnet_az2_private_1.id]
}

# Create RDS instance
resource "aws_db_instance" "MyDBInstance" {
  identifier             = "my-db-instance"
  allocated_storage      = var.rds_allocated_storage
  engine                 = var.rds_engine
  engine_version         = var.rds_engine_version
  instance_class         = var.rds_instance_class
  publicly_accessible    = false
  username               = var.rds_username
  password               = var.rds_password
  db_subnet_group_name   = aws_db_subnet_group.my_db_subnet_group.name
  parameter_group_name   = var.rds_parameter_group_name
  option_group_name      = var.rds_option_group_name
  vpc_security_group_ids = [aws_security_group.db-sg.id]

  tags = {
    Name = "MySQL DB Instance"
  }


}