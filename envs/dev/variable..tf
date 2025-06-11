variable "project_prefix" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "hash_key" {
  type    = string
  default = "email"
}
variable "hash_key_type" {
  type    = string
  default = "S"
}
variable "stream_enabled" {
  type    = bool
  default = true
}
variable "stream_view_type" {
  type    = string
  default = "NEW_AND_OLD_IMAGES"
}


