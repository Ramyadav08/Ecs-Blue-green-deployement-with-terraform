
variable "project_name" {
  description = "Project name used for naming ECS resources"
  type        = string
}


variable "ecs_cluster_name" {
  description = "Name of the ECS Cluster to join"
  type        = string
}


variable "vpc_id" {
  description = "VPC ID where ECS instances will be launched"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs where ECS instances will run"
  type        = list(string)
}

variable "ecs_sg_id" {
  description = "Security group ID to attach to ECS instances"
  type        = string
}


variable "ecs_ami_id" {
  description = "AMI ID for ECS container instances (Amazon Linux 2 ECS Optimized AMI recommended)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for ECS cluster nodes"
  type        = string
}

variable "ssh_key_name" {
  description = "SSH key pair name to access ECS instances"
  type        = string
}

variable "ecs_instance_profile_name" {
  description = "IAM instance profile name for ECS instances"
  type        = string
}

######################################
# Auto Scaling Group
######################################
variable "asg_max_size" {
  description = "Maximum number of ECS instances in the ASG"
  type        = number
}

variable "asg_min_size" {
  description = "Minimum number of ECS instances in the ASG"
  type        = number
}

variable "asg_desired_capacity" {
  description = "Desired number of ECS instances in the ASG"
  type        = number
}

######################################
# Tags
######################################
variable "tags" {
  description = "A map of tags to associate with resources"
  type        = map(string)
  default     = {}
}
