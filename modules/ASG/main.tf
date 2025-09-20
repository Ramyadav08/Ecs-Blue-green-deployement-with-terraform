
resource "aws_launch_template" "ecs_lt" {
  name_prefix   = "${var.project_name}-lt-"
  image_id      = var.ecs_ami_id
  instance_type = var.instance_type
  key_name      = var.ssh_key_name

  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
    cluster_name = var.ecs_cluster_name
  }))

  iam_instance_profile {
    name = var.ecs_instance_profile_name
  }

  network_interfaces {
    security_groups = [var.ecs_sg_id]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-launch-template"
  })
}


resource "aws_autoscaling_group" "ecs_asg" {
  name                = "${var.project_name}-ecs-asg"
  vpc_zone_identifier = var.private_subnets
  max_size            = var.asg_max_size
  min_size            = var.asg_min_size
  desired_capacity    = var.asg_desired_capacity

  launch_template {
    id      = aws_launch_template.ecs_lt.id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 80
      instance_warmup        = 300
    }
    triggers = ["launch_template"]
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-ecs-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.project_name}-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ecs_asg.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.project_name}-scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ecs_asg.name
}






# Alarm for High CPU Utilization - Triggers Scale Up
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.project_name}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2                  
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60                 
  statistic           = "Average"
  threshold           = 70                 

  alarm_description   = "Alarm when ECS cluster CPU > 70% for 2 consecutive periods"
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ecs_asg.name
  }

  depends_on = [aws_autoscaling_policy.scale_up]
}

# Alarm for Low CPU Utilization - Triggers Scale Down
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${var.project_name}-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 30               

  alarm_description   = "Alarm when ECS cluster CPU < 30% for 2 consecutive periods"
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ecs_asg.name
  }

  depends_on = [aws_autoscaling_policy.scale_down]
}
