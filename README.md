<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.6  |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0  |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0  |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.main_cloudwatch_log_group_container_definition_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_task_definition.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.main_ecs_task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.main_ecs_task_execution_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_ssm_parameter.application_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.application_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.cost_center](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.env](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.owner_email](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_containerDefinitions"></a> [containerDefinitions](#input\_containerDefinitions) | A list of valid container definitions provided as a single valid JSON document. Please note that you should only provide values that are part of the container definition document. For a detailed description of what parameters are available, see the Task Definition Parameters section from the official Developer Guide. | `any` | n/a | yes |
| <a name="input_family"></a> [family](#input\_family) | n/a | `string` | n/a | yes |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | Number of cpu units used by the task. If the requires\_compatibilities is FARGATE this field is required. | `string` | `null` | no |
| <a name="input_ecs_task_role_custom_policies"></a> [ecs\_task\_role\_custom\_policies](#input\_ecs\_task\_role\_custom\_policies) | n/a | <pre>object({<br>    name   = optional(string)<br>    policy = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_ephemeralStorage"></a> [ephemeralStorage](#input\_ephemeralStorage) | The amount of ephemeral storage to allocate for the task. This parameter is used to expand the total amount of ephemeral storage available, beyond the default amount, for tasks hosted on AWS Fargate. | <pre>object({<br>    sizeInGiB = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_inferenceAccelerators"></a> [inferenceAccelerators](#input\_inferenceAccelerators) | n/a | <pre>list(object({<br>    DeviceName = string<br>    DeviceType = string<br>  }))</pre> | `[]` | no |
| <a name="input_ipcMode"></a> [ipcMode](#input\_ipcMode) | IPC resource namespace to be used for the containers in the task The valid values are host, task, and none. | `string` | `null` | no |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0. If you select 0, the events in the log group are always retained and never expire. | `string` | `30` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | Amount (in MiB) of memory used by the task. If the requires\_compatibilities is FARGATE this field is required. | `string` | `null` | no |
| <a name="input_networkMode"></a> [networkMode](#input\_networkMode) | Docker networking mode to use for the containers in the task. Valid values are none, bridge, awsvpc, and host. | `string` | `null` | no |
| <a name="input_pidMode"></a> [pidMode](#input\_pidMode) | Process namespace to use for the containers in the task. The valid values are host and task. | `string` | `null` | no |
| <a name="input_placementConstraints"></a> [placementConstraints](#input\_placementConstraints) | Configuration block for rules that are taken into consideration during task placement. Maximum number of placement\_constraints is 10. Detailed below. | <pre>list(object({<br>    Expression = optional(string)<br>    Type       = string<br>  }))</pre> | `[]` | no |
| <a name="input_proxyConfiguration"></a> [proxyConfiguration](#input\_proxyConfiguration) | Configuration block for the App Mesh proxy. | <pre>object({<br>    ContainerName                = string<br>    ProxyConfigurationProperties = object({})<br>    Type                         = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_requiresCompatibilities"></a> [requiresCompatibilities](#input\_requiresCompatibilities) | Set of launch types required by the task. The valid values are EC2 and FARGATE. | `list(string)` | `null` | no |
| <a name="input_runtimePlatform"></a> [runtimePlatform](#input\_runtimePlatform) | Configuration block for runtime\_platform that containers in your task may use. | <pre>object({<br>    operatingSystemFamily = optional(string)<br>    cpuArchitecture       = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_skip_destroy"></a> [skip\_destroy](#input\_skip\_destroy) | Whether to retain the old revision when the resource is destroyed or replacement is necessary. Default is false. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_main_cloudwatch_log_group_container_definition_logs"></a> [main\_cloudwatch\_log\_group\_container\_definition\_logs](#output\_main\_cloudwatch\_log\_group\_container\_definition\_logs) | The log group by which containers in your task defintion send log information to CloudWatch Logs |
| <a name="output_main_ecs_task_definition"></a> [main\_ecs\_task\_definition](#output\_main\_ecs\_task\_definition) | The AWS resource necessary to run docker containers in ECS. |
| <a name="output_main_ecs_task_execution_role"></a> [main\_ecs\_task\_execution\_role](#output\_main\_ecs\_task\_execution\_role) | The task iam role created to allow the Amazon ECS container and Fargate agents permission to make AWS API calls on your behalf. |
<!-- END_TF_DOCS -->