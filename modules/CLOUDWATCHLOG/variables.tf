variable "project_name" {
  description = "Project name to be used for naming ECS log group."
  type        = string
}

variable "retention_in_days" {
  description = "The number of days to retain log events in the CloudWatch Log Group."
  type        = number
  default     = 30
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}
}
