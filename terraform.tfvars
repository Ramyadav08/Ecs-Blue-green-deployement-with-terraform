region       = "ap-south-1"
project_name = "bluegreen"
environment  = "dev"
vpc_cidr     = "10.0.0.0/16"
ecr_repos    = ["pythonbluegreen"]
image_url = "628835453448.dkr.ecr.ap-south-1.amazonaws.com/pythonbluegreen:latest"
container_name = "pythonbluegreen"
desired_count  = 1

ecs_ami_id           = "ami-099e6eee4720726e1" 
instance_type        = "t2.medium"
ssh_key_name         = "ram-key"
asg_max_size         = 2
asg_min_size         = 1
asg_desired_capacity = 1