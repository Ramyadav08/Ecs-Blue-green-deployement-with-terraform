

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = var.retention_in_days

  lifecycle {
    prevent_destroy = false
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-ecs-logs"
  })
}
