provider "aws" {
    version = "~> 2.0"
    region  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "aws-fargate-course-state"
    key    = "courses/aws/fargate/state"
    region = "us-east-1"
  }
}
