terraform {
  backend "s3" {
    bucket         = "terraformtfstatebucket1"
    key            = "staging/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "bootcamp-4-tf-locks"
  }
}
