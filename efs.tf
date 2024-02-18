resource "aws_efs_file_system" "efs-web" {
  creation_token   = var.efs_creation_token
  encrypted        = var.efs_encrypted
  performance_mode = var.efs_performance_mode
  throughput_mode  = var.efs_throughput_mode

  tags = {
    Name = "my-efs"
  }
}

resource "aws_efs_mount_target" "aws_efs_mount_target" {
  file_system_id  = aws_efs_file_system.efs-web.id
  subnet_id       = aws_subnet.subnet_az1_private_1.id
  security_groups = [aws_security_group.efs_sg.id]
}