data "aws_iam_policy_document" "main_ecs_task_execution_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}

data "aws_ssm_parameter" "application_id" {
  name = "hccp-app-id"
}

data "aws_ssm_parameter" "application_name" {
  name = "hccp-app"
}

data "aws_ssm_parameter" "cost_center" {
  name = "hccp-cost-center"
}

data "aws_ssm_parameter" "env" {
  name = "hccp-environment"
}

data "aws_ssm_parameter" "owner_email" {
  name = "hccp-owner"
}