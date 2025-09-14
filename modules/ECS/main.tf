resource "aws_ecs_cluster" "this" {
  name = "${var.project_name}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-ecs-cluster"
  })
}

# Private DNS namespace
resource "aws_service_discovery_private_dns_namespace" "this" {
  name        = "${var.project_name}.local"
  description = "Private DNS namespace for ECS services"
  vpc         = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.project_name}-cloudmap-namespace"
  })
}

# Cloud Map Service
resource "aws_service_discovery_service" "this" {
  name         = "${var.project_name}-sd-service"
  namespace_id = aws_service_discovery_private_dns_namespace.this.id

  dns_config {
    namespace_id   = aws_service_discovery_private_dns_namespace.this.id
    routing_policy = "MULTIVALUE"

    dns_records {
      type = "A"
      ttl  = 10
    }
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-sd-service"
  })
}

# ECS Task Definition (EC2, awsvpc network mode)
resource "aws_ecs_task_definition" "this" {
  family                   = "${var.project_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = var.ecs_task_execution_role_arn

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.image_url
      essential = true
      cpu = 256 
      memory = 512
      portMappings = [
        {
          containerPort = 5000   # Match Flask app
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project_name}"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = merge(var.tags, {
    Name = "${var.project_name}-task"
  })

}

# ECS Service with ALB blue/green
resource "aws_ecs_service" "this" {
  name            = "${var.project_name}-ecs-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count
  launch_type     = "EC2"

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [var.ecs_service_sg_id]
    assign_public_ip = false
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  load_balancer {
    target_group_arn = var.blue_target_group_arn
    container_name   = var.container_name
    container_port   = 5000    # Must match task definition
  }

  service_registries {
    registry_arn = aws_service_discovery_service.this.arn
  }

  depends_on = [aws_ecs_task_definition.this]
  lifecycle {
    ignore_changes = [
      task_definition
    ]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-ecs-service"
  })
}
