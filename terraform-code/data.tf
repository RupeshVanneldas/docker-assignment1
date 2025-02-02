# Fetch the latest Amazon Linux 2 AMI for EC2 instances
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"] # The AMI must be owned by Amazon
  most_recent = true       # Fetch the most recent version of the AMI
  filter {
    name   = "name"                         # Filter based on AMI name
    values = ["amzn2-ami-hvm-*-x86_64-gp2"] # Match AMI names for Amazon Linux 2 with HVM virtualization and gp2 storage
  }
}

# Data source to retrieve an IAM instance profile for EC2
# This profile will be associated with EC2 instances
data "aws_iam_instance_profile" "instance_profile" {
  name = "LabInstanceProfile" # Name of the instance profile (ensure this profile exists in IAM or you will need to create it)
}

# Data source to retrieve the list of availability zones in the 'us-east-1' region
data "aws_availability_zones" "available" {
  state = "available" # Filter only the availability zones that are available (not disabled or unavailable)
}

# Data block to retrieve the default VPC id in the current region
data "aws_vpc" "default" {
  default = true # Retrieve the default VPC in the region (if it exists)
}

# Local variables to handle common tags and naming conventions
locals {
  # Merge default tags from a variable with an 'env' tag (e.g., 'dev', 'prod')
  default_tags = merge(var.default_tags, { "env" = var.env })

  # Define a naming convention for resources using the prefix and environment variables
  name_prefix = "${var.prefix}-${var.env}"
}
