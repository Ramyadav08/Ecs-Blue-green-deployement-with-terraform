output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_instance_profile" {
  value = aws_iam_instance_profile.ecs_instance_profile.name
}

output "codedeploy_role_arn" {
  value = aws_iam_role.codedeploy_role.arn
}