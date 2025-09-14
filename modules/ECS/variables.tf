variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}



variable "vpc_id" {
  description = "VPC ID where ECS will be deployed"
  type        = string
}







variable "ecs_task_execution_role_arn" {
  description = "The ARN of the IAM role that allows your Amazon ECS container tasks to make calls to AWS APIs on your behalf."
  type        = string  
  
}


variable "container_name" {
  description = "The name of the container."
  type        = string  
  
}

variable "image_url" {
  description = "The URL of the container image."
  type        = string  
  
}

variable "region" {
  description = "The AWS region to deploy to."
  type        = string
  
}


variable "desired_count" {
  description = "The number of instances of the task definition to place and keep running in your service."
  type        = number
  
}



variable "private_subnets" {
  description = "List of private subnet IDs for the ECS service."
  type        = list(string)
  
}


variable "blue_target_group_arn" {
  description = "ARN of the blue target group for CodeDeploy."
  type        = string
  
}

variable "ecs_service_sg_id" {
  description = "Security Group ID for the ECS service."
  type        = string
  
}
