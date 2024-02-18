# Create a Load Balancer
resource "aws_lb" "my_load_balancer" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = var.lb_type
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.subnet_az1_public_1.id, aws_subnet.subnet_az2_public_1.id]

  tags = {
    Name = "My-Web-LB"
  }
}

# Create a Target group for the Load Balancer
resource "aws_lb_target_group" "my_target_group" {
  name     = var.tg_name
  port     = var.tg_port
  protocol = var.tg_protocol
  vpc_id   = aws_vpc.my_vpc.id

  health_check {
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 60
  }
}

# Create a target for the Target group
resource "aws_lb_target_group_attachment" "my_web_target_attachment" {
  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = aws_instance.myec2.id
}

# Create a listener for the Load Balancer which in our case is our target group
resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_load_balancer.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}