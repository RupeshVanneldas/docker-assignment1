terraform {
  # Define the required providers for the project
  required_providers {
    # AWS provider configuration
    aws = {
      source  = "hashicorp/aws" # Specifies the source of the AWS provider
      version = ">= 3.27"       # Specifies the version constraint for the AWS provider
    }
  }

  # Define the required version of Terraform
  required_version = ">= 0.14" # Ensures Terraform version is at least 0.14

  # Backend configuration to store the Terraform state in an S3 bucket
  backend "s3" {
    bucket = "<your-s3-bucket-name>" # Replace with your S3 bucket name to store state
    key    = "terraform.tfstate"     # The key (path) for the state file in the S3 bucket
    region = "us-east-1"             # The AWS region where the S3 bucket is located
  }
}
