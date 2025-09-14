variable "project_name" {
    description = "The name of the project."
    type        = string
    default     = "ram"
  
}

variable "public_subnets" {
    description = "List of public subnet IDs."
    type        = list(string)
  
}

variable "vpc_id" {
    description = "The ID of the VPC where the ALB will be created."
    type        = string
  
}



variable "alb_sg_id" {
  description = "ALB Security Group ID"
  type        = string
}


variable "tags" {
  description = "A map of tags to assign to the ALB resources"
  type        = map(string)
  default     = {}
  
}