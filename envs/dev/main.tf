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

