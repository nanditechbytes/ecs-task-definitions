variable "family" {
  type = string
}

variable "inferenceAccelerators" {
  type = list(object({
    DeviceName = string
    DeviceType = string
  }))
  default = []
}
variable "log_retention_in_days" {
  type        = string
  default     = 90
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0. If you select 0, the events in the log group are always retained and never expire."
}
variable "ipcMode" {
  type        = string
  default     = null
  description = "IPC resource namespace to be used for the containers in the task The valid values are host, task, and none."
}
variable "cpu" {
  type        = string
  default     = null
  description = "Number of cpu units used by the task. If the requires_compatibilities is FARGATE this field is required."
}
variable "memory" {
  type        = string
  default     = null
  description = "Amount (in MiB) of memory used by the task. If the requires_compatibilities is FARGATE this field is required."
}
variable "networkMode" {
  type        = string
  default     = null
  description = "Docker networking mode to use for the containers in the task. Valid values are none, bridge, awsvpc, and host."
}
variable "runtimePlatform" {
  type = object({
    operatingSystemFamily = optional(string)
    cpuArchitecture       = optional(string)
  })
  default     = null
  description = "Configuration block for runtime_platform that containers in your task may use."
}
variable "containerDefinitions" {
  description = "A list of valid container definitions provided as a single valid JSON document. Please note that you should only provide values that are part of the container definition document. For a detailed description of what parameters are available, see the Task Definition Parameters section from the official Developer Guide."
  type        = any
}
variable "placementConstraints" {
  type = list(object({
    Expression = optional(string)
    Type       = string
  }))
  default     = []
  description = "Configuration block for rules that are taken into consideration during task placement. Maximum number of placement_constraints is 10. Detailed below."
}
variable "proxyConfiguration" {
  type = object({
    ContainerName                = string
    ProxyConfigurationProperties = object({})
    Type                         = optional(string)
  })
  default     = null
  description = "Configuration block for the App Mesh proxy."
}

variable "ephemeralStorage" {
  type = object({
    sizeInGiB = optional(string)
  })
  default     = null
  description = "The amount of ephemeral storage to allocate for the task. This parameter is used to expand the total amount of ephemeral storage available, beyond the default amount, for tasks hosted on AWS Fargate."
}
variable "pidMode" {
  type        = string
  default     = null
  description = "Process namespace to use for the containers in the task. The valid values are host and task."
}
variable "requiresCompatibilities" {
  type        = list(string)
  default     = null
  description = "Set of launch types required by the task. The valid values are EC2 and FARGATE."
}
variable "skip_destroy" {
  type        = bool
  default     = true
  description = "Whether to retain the old revision when the resource is destroyed or replacement is necessary. Default is false."
}
variable "taskRoleArn" {
  type        = string
  default     = ""
  description = "(Optional) ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services.  If not specified, one will be created automatically."
}
variable "executionRoleArn" {
  type        = string
  default     = ""
  description = "(Optional) ARN of IAM role that grants the Amazon ECS container agent permission to make AWS API calls on your behalf."
}
variable "ecs_task_role_custom_policies" {
  type = object({
    name   = optional(string)
    policy = optional(string)
  })
  default = null
}
