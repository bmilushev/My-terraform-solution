# Create an ASG
resource "aws_autoscaling_group" "my_web_asg" {
  name             = var.asg_name
  max_size         = 3
  min_size         = 1
  desired_capacity = 1
  launch_template {
    id      = aws_launch_template.my_launch_template.id
    version = "$Latest"
  }
  vpc_zone_identifier = [aws_subnet.subnet_az1_private_1.id, aws_subnet.subnet_az2_private_1.id]
  target_group_arns   = [aws_lb_target_group.my_target_group.id]
}

# Create launch template for the ASG
resource "aws_launch_template" "my_launch_template" {
  name                   = "my-launch-template"
  image_id               = var.instance_ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  user_data              = filebase64("ec2-user-data.sh")

  iam_instance_profile {
    name = "my-ec2-web-profile"
  }

  ebs_optimized = false

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Bozho-web-test"
    }
  }
}

# Create a "scale in" policy for the ASG
resource "aws_autoscaling_policy" "scale_in" {
  name                   = var.asg_scale_in_policy_name
  autoscaling_group_name = var.asg_name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120
}

# Create a CW alarm for the "scale in" policy
resource "aws_cloudwatch_metric_alarm" "scale_in" {
  alarm_description   = "Monitors CPU utilization for my-web-asg"
  alarm_actions       = [aws_autoscaling_policy.scale_in.arn]
  alarm_name          = var.asg_scale_in_policy_alarm-name
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "10"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
}

# Create a "scale out" policy for the ASG
resource "aws_autoscaling_policy" "scale_out" {
  name                   = var.asg_scale_out_policy_name
  autoscaling_group_name = var.asg_name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 120
}

# Create a CW alarm for the "scale out" policy
resource "aws_cloudwatch_metric_alarm" "scale_out" {
  alarm_description   = "Monitors CPU utilization for my-web-asg"
  alarm_actions       = [aws_autoscaling_policy.scale_out.arn]
  alarm_name          = var.asg_scale_out_policy_alarm-name
  comparison_operator = "GreaterThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "85"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
}
