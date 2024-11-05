output "main_ecs_task_definition" {
  value       = aws_ecs_task_definition.main
  description = "The AWS resource necessary to run docker containers in ECS."
}
output "main_ecs_task_execution_role" {
  value       = aws_iam_role.main_ecs_task_execution_role
  description = "The task iam role created to allow the Amazon ECS container and Fargate agents permission to make AWS API calls on your behalf. "
}
output "main_cloudwatch_log_group_container_definition_logs" {
  value       = aws_cloudwatch_log_group.main_cloudwatch_log_group_container_definition_logs
  description = "The log group by which containers in your task defintion send log information to CloudWatch Logs"
}