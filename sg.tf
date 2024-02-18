## SG for my EC2
resource "aws_security_group" "web-sg" {
  name        = var.security_group_ec2_name
  description = "SG for my Web EC2"

  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "SSH to EC2"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    description     = "HTTP from VPC"
    security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## SG for my DB
resource "aws_security_group" "db-sg" {
  name        = var.security_group_db_name
  description = "SG for my RDS"

  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    description     = "EC2 to RDS"
    security_groups = [aws_security_group.web-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## SG for my ALB
resource "aws_security_group" "lb_sg" {
  name        = var.security_group_name_alb
  description = "Security group for My-Web-LB"

  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## SG for my EFS
resource "aws_security_group" "efs_sg" {
  name        = var.efs_sg_name
  description = "Allows inbound traffic from EC2 & RDS"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.web-sg.id, aws_security_group.db-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}