# Variable for default tags to apply to resources
variable "default_tags" {
  default = {
    "Owner" = "Rupesh-Vanneldas" # The owner of the resources (adjust as needed)
    "App"   = "Assignment"       # The application name (adjust to your use case)
  }
  type        = map(any)       # A map to allow dynamic key-value pairs for tags
  description = "Default tags" # Description of what this variable represents
}

# Variable for the namespace prefix (usually used for naming conventions)
variable "prefix" {
  default     = "assignment"       # Default prefix for resources
  type        = string             # Ensures the value is a string
  description = "Namespace prefix" # Description of what the prefix is used for
}

# Variable for the deployment environment (e.g., dev, staging, prod)
variable "env" {
  default     = "prod"                   # Default environment is 'prod'
  type        = string                   # Ensures the value is a string
  description = "Deployment Environment" # Description of the environment variable
  validation {
    condition     = contains(["dev", "staging", "test", "prod"], var.env)   # Ensures the environment is one of the allowed values
    error_message = "Environment must be one of: dev, staging, test, prod." # Custom error message if the validation fails
  }
}

# Variable for instance types based on the environment
variable "instance_type" {
  default = {
    "prod"    = "t3.medium" # Instance type for the 'prod' environment
    "test"    = "t3.micro"  # Instance type for the 'test' environment
    "staging" = "t2.micro"  # Instance type for the 'staging' environment
    "dev"     = "t2.micro"  # Instance type for the 'dev' environment
  }
  description = "Type of the instance" # Description of what this variable represents
  type        = map(string)            # A map with environment names as keys and instance types as values
}
