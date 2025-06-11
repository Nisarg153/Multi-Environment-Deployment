provider "aws" {
  region = "us-east-1"
}

module "iam" {
  source         = "../../modules/iam"
  project_prefix = var.project_prefix
  environment    = var.environment
}
# This file is part of the Terraform Bootcamp project.
module "vpc" {
  source               = "../../modules/vpc"
  project_prefix       = var.project_prefix
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "dynamodb" {
  source         = "../../modules/dynamodb"
  project_prefix = var.project_prefix
  environment    = var.environment
  aws_region     = var.aws_region
}

module "ec2" {
  source                    = "../../modules/ec2"
  project_prefix            = var.project_prefix
  environment               = var.environment
  vpc_id                    = module.vpc.vpc_id
  public_subnets            = module.vpc.public_subnets
  private_subnets           = module.vpc.private_subnets
  iam_instance_profile_name = var.iam_instance_profile_name
  # Add other required variables here (e.g., ami_id, instance_type, etc.)
}