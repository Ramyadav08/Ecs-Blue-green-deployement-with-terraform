variable "region" {
  description = "The AWS region to deploy to."
  type        = string

}

variable "project_name" {
  description = "The name of the project."
  type        = string


}

variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)."
  type        = string

}



variable "vpc_cidr" {
  type = string

}


variable "ecr_repos" {
  description = "List of ECR repositories to create"
  type        = list(string)

}


variable "image_url" {
  description = "The URL of the container image."
  type        = string  
  
}


variable "container_name" {
  description = "The name of the container."
  type        = string  
  
}

variable "desired_count" {
  description = "The number of instances of the task definition to place and keep running in your service."
  type        = number
  
}




variable "ecs_ami_id" {
  description = "AMI ID for ECS EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for ECS instances"
  type        = string
}

variable "ssh_key_name" {
  description = "SSH key name for accessing ECS instances"
  type        = string
}

variable "asg_max_size" {
  description = "Maximum size of the ASG"
  type        = number
}

variable "asg_min_size" {
  description = "Minimum size of the ASG"
  type        = number
}

variable "asg_desired_capacity" {
  description = "Desired capacity of the ASG"
  type        = number
}





