data "aws_availability_zones" "available" {}


locals {
  newbits = 8

  netcount = 9

  all_subnets = [for i in range(local.netcount) : cidrsubnet(var.vpc_cidr, local.newbits, i)]

  
  public_subnets  = slice(local.all_subnets, 0, 3)
  private_subnets = slice(local.all_subnets, 3, 6)
  database_subnets= slice(local.all_subnets,6,9)
}


module "vpc" {
  
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.17.0"
  name = var.vpc_name

  azs = slice(data.aws_availability_zones.available.names, 0, 3)

  cidr = var.vpc_cidr

  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  database_subnets = local.database_subnets
  
  create_database_subnet_group = true
  create_database_subnet_route_table = true

  # create nat gateways
  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  # enable dns hostnames and support
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  # tags for public, private,database subnets and vpc
  tags                = var.tags
  public_subnet_tags  = var.additional_public_subnet_tags
  private_subnet_tags = var.additional_private_subnet_tags
  database_subnet_tags= var.additional_database_subnet_tags



  map_public_ip_on_launch = true

}
