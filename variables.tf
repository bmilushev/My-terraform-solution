## Variables for VPC
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

### Variables for SG names

variable "security_group_db_name" {
  description = "Name for the security group"
  default     = "db-sg"
}

variable "security_group_ec2_name" {
  description = "Name for the security group"
  default     = "web-sg"
}
variable "security_group_name_alb" {
  description = "Name for the security group ALB"
  default     = "web-alb-sg"
}

# Variables for EC2
variable "instance_ami" {
  description = "AMI for EC2"
  default     = "ami-089c89a80285075f7"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "key for EC2"
  default     = "my-web-key-pair"
}

## Variables for RDS

variable "rds_allocated_storage" {
  type    = string
  default = "20"
}
variable "rds_engine" {
  type    = string
  default = "mysql"
}
variable "rds_engine_version" {
  type    = string
  default = "8.0.33"
}
variable "rds_instance_class" {
  type    = string
  default = "db.t2.micro"
}

variable "rds_username" {
  type    = string
  default = "admin"
}
variable "rds_password" {
  type    = string
  default = "password"
}
variable "rds_parameter_group_name" {
  type    = string
  default = "default.mysql8.0"
}

variable "rds_option_group_name" {
  type    = string
  default = "default:mysql-8-0"
}

## Variables for ALB

variable "lb_name" {
  description = "Name for the ALB"
  default     = "My-Web-LB"
}

variable "tg_name" {
  description = "Name for the Target group"
  default     = "My-Web-TG"
}

variable "tg_port" {
  default = "80"
}

variable "tg_protocol" {
  default = "HTTP"
}

variable "lb_internal" {
  default = "false"
}

variable "listener_port" {
  default = "80"
}
variable "listener_protocol" {
  default = "HTTP"
}
variable "lb_type" {
  default = "application"
}

## Variables for CloudWatch Alarm & SNS topic

variable "cloudwatch_alarm_name" {
  default = "ALB-Requests-Alarm"
}
variable "cloudwatch_comparison_operator" {
  default = "GreaterThanOrEqualToThreshold"
}

variable "cloudwatch_evaluation_periods" {
  default = "2"
}
variable "cloudwatch_metric_name" {
  default = "RequestCount"
}
variable "cloudwatch_namespace" {
  default = "AWS/ApplicationELB"
}

variable "cloudwatch_period" {
  default = "300"
}
variable "cloudwatch_statistic" {
  default = "SampleCount"
}
variable "cloudwatch_threshold" {
  default = "100"
}

variable "cloudwatch_alarm_description" {
  default = "Alarm when ALB requests exceed 100"
}


variable "sns_topic_name" {
  default = "SNS-ALB-Request-Alarm"
}

variable "sns_endpoint_email" {
  default = "buji9397@gmail.com"
}

## Variables for EFS

variable "efs_creation_token" {
  default = "efs-web"
}

variable "efs_performance_mode" {
  default = "generalPurpose"
}

variable "efs_throughput_mode" {
  default = "bursting"
}
variable "efs_encrypted" {
  default = "true"
}

variable "efs_sg_name" {
  default = "efs-sg"
}

## Variables for ASG

variable "asg_launch_config_name" {
  default = "web-launch-config"
}

variable "asg_name" {
  default = "my-web-asg"
}

variable "asg_scale_in_policy_name" {
  default = "Scale-in-policy"
}

variable "asg_scale_in_policy_alarm-name" {
  default = "my-web-asg_scale_in"
}

variable "asg_scale_out_policy_name" {
  default = "Scale-out-policy"
}

variable "asg_scale_out_policy_alarm-name" {
  default = "my-web-asg_scale_out"
}