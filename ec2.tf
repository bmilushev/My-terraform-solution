resource "aws_instance" "myec2" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.subnet_az1_private_1.id
  iam_instance_profile        = "my-ec2-web-profile"
  user_data                   = file("ec2-user-data.sh")
  associate_public_ip_address = false
  key_name = var.key_name
  vpc_security_group_ids      = [aws_security_group.web-sg.id]

  root_block_device {
    delete_on_termination = true
    volume_type           = "gp3"
    volume_size           = 20
  }

  tags = {
    Name = "Bozho-test-instance"
    Env  = "Test"
    App  = "WebApp"
  }


}