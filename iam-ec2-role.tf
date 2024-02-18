# Create an instance profile for the IAM role
resource "aws_iam_instance_profile" "my_ec2_web_profile" {
  name = "my-ec2-web-profile"
  role = aws_iam_role.role.name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Create the IAM role for my EC2 instance
resource "aws_iam_role" "role" {
  name               = "MyEc2WebRole"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Attach required policies for the IAM role
resource "aws_iam_role_policy_attachment" "amazaon-ssm-directory-service-access" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMDirectoryServiceAccess"
}

resource "aws_iam_role_policy_attachment" "amazaon-ec2-role-for-ssm" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "amazon-ssm-managed-instance-core" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
