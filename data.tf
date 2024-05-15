data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_availability_zones" "available" {}
data "aws_iam_policy" "cloudwatch_log_full_policy" {
  name = "CloudWatchLogsFullAccess"
}
data "aws_iam_policy" "ssm_managed_instance_policy" {
  name = "AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_policy" {
  role       = aws_iam_role.ssm_for_ec2.name
  policy_arn = data.aws_iam_policy.ssm_managed_instance_policy.arn
}

data "aws_iam_policy" "cloudwatch_agent_server_policy" {
  name = "CloudWatchAgentServerPolicy"
}
