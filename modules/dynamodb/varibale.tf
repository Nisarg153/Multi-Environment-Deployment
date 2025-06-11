variable "enable_stream" {
  type    = bool
  default = true
}

variable "stream_view_type" {
  type    = string
  default = "NEW_AND_OLD_IMAGES"
}
variable "project_prefix" {
  type    = string
  default = "bootcamp-4"
}
variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "dev"
}