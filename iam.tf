resource "aws_iam_role" "ssm_for_ec2" {
  name               = "role-ec2ssm-virginia"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "cloudwatch_agent_server_policy" {
  role       = aws_iam_role.ssm_for_ec2.name
  policy_arn = data.aws_iam_policy.cloudwatch_agent_server_policy.arn
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "instance-profile-ec2ssm-virginia"
  role = aws_iam_role.ssm_for_ec2.name
}





