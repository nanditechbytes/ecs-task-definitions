terraform {
  required_version = "~> 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

locals {
  ecs_task_definition_configs = { for ecs_task_definition_config in jsondecode(file("app-task-definition.json")) : ecs_task_definition_config.family => ecs_task_definition_config }
}

module "ce-ecs-task-definition" {
  source                  = "../"
  for_each                = local.ecs_task_definition_configs
  family                  = lookup(each.value, "family", null)
  requiresCompatibilities = lookup(each.value, "requiresCompatibilities", null)
  cpu                     = lookup(each.value, "cpu", null)
  memory                  = lookup(each.value, "memory", null)
  networkMode             = lookup(each.value, "networkMode", null)
  containerDefinitions    = each.value["containerDefinitions"]
  log_retention_in_days   = lookup(each.value, "log_retention_in_days", null)
}