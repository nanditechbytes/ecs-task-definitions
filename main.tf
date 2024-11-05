locals {
  policy_arn_prefix    = "arn:${data.aws_partition.current.partition}:iam::aws:policy"
  account_id           = data.aws_caller_identity.current.account_id
  permissions_boundary = "arn:aws:iam::${local.account_id}:policy/EngineerOrUserServiceRolePermissions"
  cloudwatch_log_groups = flatten(
    [
      for index, containerDefinition in var.containerDefinitions : {
        name              = "ecs/${var.family}-${containerDefinition.name}"
        retention_in_days = var.log_retention_in_days
      }
    ]
  )
  containerDefinitions = flatten(
    [
      for containerDefinition in var.containerDefinitions : merge(
        containerDefinition,
        {
          logConfiguration = {
            logDriver = "awslogs"
            options = {
              awslogs-group         = "ecs/${var.family}-${containerDefinition.name}"
              awslogs-region        = data.aws_region.current.name
              awslogs-stream-prefix = "ecs"
            }
          }
        }
      )
    ]
  )
  tags = {
    application-id = data.aws_ssm_parameter.application_id.value
    application    = data.aws_ssm_parameter.application_name.value
    cost-center    = data.aws_ssm_parameter.cost_center.value
    env            = data.aws_ssm_parameter.env.value
    owner-email    = data.aws_ssm_parameter.owner_email.value
  }
}

resource "aws_ecs_task_definition" "main" {
  family                   = var.family
  container_definitions    = jsonencode(local.containerDefinitions)
  cpu                      = var.cpu
  execution_role_arn       = var.executionRoleArn == "" ? aws_iam_role.main_ecs_task_execution_role[0].arn : var.executionRoleArn
  ipc_mode                 = var.ipcMode
  memory                   = var.memory
  network_mode             = var.networkMode
  pid_mode                 = var.pidMode
  requires_compatibilities = var.requiresCompatibilities
  skip_destroy             = var.skip_destroy
  task_role_arn            = var.taskRoleArn == "" ? aws_iam_role.main_ecs_task_execution_role[0].arn : var.taskRoleArn
  dynamic "proxy_configuration" {
    for_each = var.proxyConfiguration != null ? [var.proxyConfiguration] : []
    content {
      container_name = proxyConfiguration.value.ContainerName
      type           = proxyConfiguration.value.Type
      properties     = proxyConfiguration.value.ProxyConfigurationProperties
    }
  }
  dynamic "runtime_platform" {
    for_each = var.runtimePlatform != null ? [var.runtimePlatform] : []
    content {
      operating_system_family = runtime_platform.value.operatingSystemFamily
      cpu_architecture        = runtime_platform.value.cpuArchitecture
    }
  }
  dynamic "inference_accelerator" {
    for_each = var.inferenceAccelerators
    content {
      device_name = inference_accelerator.value.DeviceName
      device_type = inference_accelerator.value.DeviceType
    }
  }
  dynamic "placement_constraints" {
    for_each = var.placementConstraints
    content {
      expression = placement_constraints.value.Expression
      type       = placement_constraints.value.Type
    }
  }
  dynamic "ephemeral_storage" {
    for_each = var.ephemeralStorage != null ? [var.ephemeralStorage] : []
    content {
      size_in_gib = ephemeral_storage.value.sizeInGiB
    }
  }
  tags = merge({ resource_name = "Amazon ECS Task Definitions" }, local.tags)
}

resource "aws_cloudwatch_log_group" "main_cloudwatch_log_group_container_definition_logs" {
  for_each = {
    for index, cloudwatch_log_group in local.cloudwatch_log_groups :
    cloudwatch_log_group.name => cloudwatch_log_group
  }
  retention_in_days = 90
  name              = each.value.name
  tags              = merge({ resource_name = "Amazon Cloudwatch Log groups" }, local.tags)
}

resource "aws_iam_role" "main_ecs_task_execution_role" {
  count                 = var.taskRoleArn == "" && var.executionRoleArn == "" ? 1 : 0
  name                  = "userServiceRole-ecsTaskExecutionRole-${var.family}"
  description           = "${var.family} - ECS Task Execution Role"
  assume_role_policy    = data.aws_iam_policy_document.main_ecs_task_execution_assume_role_policy.json
  force_detach_policies = true
  inline_policy {
    name = "Secret-ReadAccess"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : [
            "secretsmanager:GetResourcePolicy",
            "secretsmanager:GetSecretValue",
            "secretsmanager:DescribeSecret",
            "secretsmanager:ListSecretVersionIds"
          ],
          "Resource" : "arn:aws:secretsmanager:us-east-1:${data.aws_caller_identity.current.account_id}:secret:*"
        },
        {
          "Sid" : "VisualEditor1",
          "Effect" : "Allow",
          "Action" : [
            "secretsmanager:GetRandomPassword",
            "secretsmanager:ListSecrets"
          ],
          "Resource" : "*"
        }
      ]
      }
    )
  }

  inline_policy {
    name = "SSM-GetParameters"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : "ssm:GetParameters",
          "Resource" : "arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:parameter/user*"
        }
      ]
      }
    )
  }

  dynamic "inline_policy" {
    for_each = var.ecs_task_role_custom_policies != null ? [var.ecs_task_role_custom_policies] : []
    content {
      name   = inline_policy.value.name
      policy = inline_policy.value.policy
    }
  }

  managed_policy_arns  = ["${local.policy_arn_prefix}/service-role/AmazonECSTaskExecutionRolePolicy"]
  permissions_boundary = local.permissions_boundary
  tags                 = merge({ resource_name = "AWS Identity and Access Management" }, local.tags)
}
