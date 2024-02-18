resource "aws_nat_gateway" "myNATgw" {
  allocation_id = aws_eip.My_EIP.id
  subnet_id     = aws_subnet.subnet_az1_public_1.id

  tags = {
    Name = "My-Test-NAT-GW"
  }
}