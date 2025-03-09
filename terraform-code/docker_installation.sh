#!/bin/bash
# The shebang line defines the shell to use for executing the script (bash).

# Update all installed packages to the latest version
sudo yum update -y  # `yum` is the default package manager on Amazon Linux, and `-y` auto-approves updates.

# Install Docker
sudo yum install -y docker git  # This installs the Docker and Git package.

# Start the Docker service
sudo systemctl start docker  # `systemctl` starts the Docker service to allow containers to run.

# Enable Docker to start on boot
sudo systemctl enable docker  # Ensures Docker starts automatically when the instance reboots.

# Add the `ec2-user` to the Docker group
sudo usermod -aG docker ec2-user  # Adds the `ec2-user` to the Docker group, allowing the user to run Docker commands without `sudo`.