terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.27.0"
    }
  }
  backend "s3" {
  bucket         = "jenkins-state-demo-1234"
  key            = "terraform.tfstate"
  region         = "us-east-1"
  dynamodb_table = "jenkins-state-lock-table"
  encrypt        = true
  profile = "terraform-user"
}
}



provider "aws" {
  # Configuration options
    region = "us-east-1"
    profile = "terraform-user"
}


# 1. Fetch the existing resource info
data "aws_caller_identity" "current" {}
output "aws_account_id" { value = data.aws_caller_identity.current.account_id }
output "aws_user_arn"    { value = data.aws_caller_identity.current.arn }
output "caller_user_id" { value = data.aws_caller_identity.current.user_id }