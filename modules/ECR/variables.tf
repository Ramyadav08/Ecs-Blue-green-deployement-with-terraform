variable "ecr_repos" {
  description = "List of ECR repository names"
  type        = list(string)
}

variable "image_tag_mutability" {
  description = "Tag mutability setting for ECR repositories"
  type        = string
  default     = "MUTABLE"
}