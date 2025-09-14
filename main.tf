locals {
  stack_name = "${var.environment}-${var.project_name}"
  default_tags = {
    Terraform   = true
    Project     = var.project_name
    Region      = var.region
    Environment = var.environment
  }
}

module "vpc" {
  source   = "./modules/VPC"
  vpc_name = "${local.stack_name}-vpc"
  vpc_cidr = var.vpc_cidr
}


module "ecr" {
  source    = "./modules/ECR"
  ecr_repos = var.ecr_repos
}

module "sg" {
  source       = "./modules/SG"
  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
}

module "iam" {
  source       = "./modules/IAM"
  project_name = var.project_name

}

module "alb" {
  source         = "./modules/ALB"
  project_name   = var.project_name
  public_subnets = module.vpc.public_subnets
  vpc_id         = module.vpc.vpc_id
  alb_sg_id      = module.sg.alb_sg_id
  tags           = local.default_tags
}


module "ecs" {
  source                      = "./modules/ECS"
  project_name                = var.project_name
  private_subnets             = module.vpc.private_subnets
  vpc_id                      = module.vpc.vpc_id
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  image_url                   = var.image_url
  container_name              = var.container_name
  desired_count               = var.desired_count
  region                      = var.region
  tags                        = local.default_tags
  blue_target_group_arn       = module.alb.blue_target_group_arn
  ecs_service_sg_id           = module.sg.ecs_sg_id

}

module "asg" {
    source       = "./modules/ASG"
    project_name = var.project_name
    vpc_id       = module.vpc.vpc_id
    ecs_sg_id    = module.sg.ecs_sg_id
    ecs_instance_profile_name = module.iam.ecs_instance_profile
    ecs_ami_id   = var.ecs_ami_id
    instance_type = var.instance_type
    ssh_key_name = var.ssh_key_name
    asg_max_size = var.asg_max_size
    asg_min_size = var.asg_min_size
    asg_desired_capacity = var.asg_desired_capacity
    tags         = local.default_tags
    private_subnets = module.vpc.private_subnets
    ecs_cluster_name = module.ecs.ecs_cluster_name
  
}

module "cloudlog" {
    source       = "./modules/CLOUDWATCHLOG"
    project_name = var.project_name
    
  
}


module "codedeploy" {
  source            = "./modules/CODE-DEPLOY"
  project_name      = var.project_name
  ecs_cluster_name  = module.ecs.ecs_cluster_name
  ecs_service_name  = module.ecs.ecs_service_name
  codedeploy_role_arn    = module.iam.codedeploy_role_arn
  blue_target_group_name = module.alb.blue_target_group_name
  green_target_group_name = module.alb.green_target_group_name
  alb_listener_arn = module.alb.alb_listener_arn
  tags                  = local.default_tags
  
}