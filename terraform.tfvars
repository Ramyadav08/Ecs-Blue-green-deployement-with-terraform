region       = "ap-south-1"
project_name = "bluegreen"
environment  = "dev"
vpc_cidr     = "10.0.0.0/16"
ecr_repos    = ["pythonbluegreen"]
container_name = "pythonbluegreen"
desired_count  = 1

ecs_ami_id           = "ami-099e6eee4720726e1" 
instance_type        = "t3.medium"
ssh_key_name         = "ram-key"
asg_max_size         = 2
asg_min_size         = 1
asg_desired_capacity = 1