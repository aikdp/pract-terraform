terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" { #need to create manually in AWS, then use here
    bucket         = "vpc-module-rs"
    key            = "vpc-pract-april.tfstate"
    region         = "us-east-1"
    # dynamodb_table = "vpc-module-locking"
    use_lockfile = true
    encrypt = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}  