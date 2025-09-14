variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "tags" {
  description = "Tags to apply to CodeDeploy resources"
  type        = map(string)
  default     = {}
}

variable "ecs_cluster_name" {
  description = "ECS Cluster name"
  type        = string
}

variable "ecs_service_name" {
  description = "ECS Service name"
  type        = string
}

variable "codedeploy_role_arn" {
  description = "IAM role ARN for CodeDeploy"
  type        = string
}

variable "alb_listener_arn" {
  description = "ALB Listener ARN for routing traffic"
  type        = string
}



variable "blue_target_group_name" {
  description = "Blue Target Group Name"
  type        = string
}

variable "green_target_group_name" {
  description = "Green Target Group Name"
  type        = string
}
