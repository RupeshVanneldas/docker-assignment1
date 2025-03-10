# Create an EC2 Instance
resource "aws_instance" "my_instance" {
  ami                         = data.aws_ami.latest_amazon_linux.id                 # Using the latest Amazon Linux 2 AMI
  instance_type               = lookup(var.instance_type, var.env)                  # Instance type is selected from a variable, depending on the environment
  key_name                    = aws_key_pair.my_key.key_name                        # Associating the EC2 instance with an SSH key
  vpc_security_group_ids      = [aws_security_group.my_sg.id]                       # Assigning the EC2 instance to a security group
  associate_public_ip_address = false                                               # Not assigning a public IP (use private IP for internal access)
  user_data                   = file("${path.module}/docker_installation.sh")       # Run a shell script on instance startup (e.g., install Docker)
  iam_instance_profile        = data.aws_iam_instance_profile.instance_profile.name # Associating an IAM instance profile to allow permissions
  root_block_device {
    volume_size           = 50    # Set root volume size to 50 GB (adjust as needed)
    volume_type           = "gp2" # General Purpose SSD
    delete_on_termination = true
  }
  lifecycle {
    create_before_destroy = true # Ensures the new instance is created before destroying the old one during updates
  }

  # Tags to organize and identify the instance
  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-Amazon-Linux" # Instance name based on the environment and prefix
    }
  )
}

# Create SSH Key Pair for EC2 access
resource "aws_key_pair" "my_key" {
  key_name   = local.name_prefix                # Using the naming convention for the key
  public_key = file("${local.name_prefix}.pub") # Load the public key file
}

# Security Group for EC2 instance
resource "aws_security_group" "my_sg" {
  name        = "allow app and ssh access"                    # Name for the security group
  description = "Allow 8080, 8081, 8082, 8083 and ssh access" # Description of allowed access
  vpc_id      = data.aws_vpc.default.id                       # Security group is tied to the default VPC

  # Ingress rule for SSH (port 22) access from anywhere
  ingress {
    description = "SSH and Application Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow from any IP
  }

  # Ingress rule for application ports (8081-8083)
  ingress {
    description = "Application Ports (8080-8083)"
    from_port   = 8080
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow from any IP
  }

  ingress {
    description = "DB Ports (3306)"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow from any IP
  }

  ingress {
    description = "KIND Application Ports (30000)"
    from_port   = 30000
    to_port     = 30000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow from any IP
  }

  # Egress rule allowing all outbound traffic
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"          # Allow all protocols
    cidr_blocks      = ["0.0.0.0/0"] # Allow to any IP
    ipv6_cidr_blocks = ["::/0"]      # Allow to any IPv6 address
  }

  # Tags to organize and identify the security group
  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-sg" # Security group name based on the environment and prefix
    }
  )
}

# Create an Elastic IP (EIP) and associate it with the EC2 instance
resource "aws_eip" "static_eip" {
  instance = aws_instance.my_instance.id # Associate the EIP with the created EC2 instance
  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-eip" # Name for the EIP based on the environment and prefix
    }
  )
}

# Create an Elastic Container Registry (ECR) for Docker image storage
resource "aws_ecr_repository" "ecr_repo" {
  name                 = "clo835-ass1" # Name of the ECR repository
  image_tag_mutability = "MUTABLE"     # Allow tags to be mutable (you can push images with different tags)

  # Enable image scanning on push to check for vulnerabilities
  image_scanning_configuration {
    scan_on_push = true
  }

  # Tags to organize and identify the ECR repository
  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-ecr" # ECR repository name based on the environment and prefix
    }
  )
}
