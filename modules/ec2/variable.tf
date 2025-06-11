variable "project_prefix" {
    type    = string
    default = "bootcamp-4"
}
variable "environment" {
    type    = string
    default = "dev"
}
variable "vpc_id" {
    type = string
}
variable "public_subnets" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
variable "iam_instance_profile_name" {
    type = string
}
variable "instance_type" {
  default = "t2.medium"
}
variable "ami_id" {
  default = "ami-0afc8198d221d15ea"
}
