# Docker Assignment 1

This mini-project demonstrates how to run an application with MySQL using Docker containers.  
Follow the steps below to get the application running locally.

## Prerequisites

Before you start, ensure you have the following installed:
- Docker
- Python 3.x
- `pip` for installing Python dependencies

## Setup Instructions

### Step 1: Install Necessary Packages
First, update your system's package list and install required packages:

```bash
sudo apt-get update -y
```

### Step 2: Install Python Dependencies
Install the required Python libraries using `pip`:

```bash
pip3 install -r requirements.txt
```

### Step 3: Build MySQL Docker Image
Build the MySQL Docker image:

```bash
docker build -t my_db -f Dockerfile_mysql .
```

### Step 4: Build Application Docker Image
Now, build the application Docker image:

```bash
docker build -t my_app -f Dockerfile .
```

## Running the Application

### Step 5: Start MySQL Container
Run the MySQL Docker container:

```bash
docker run -d -e MYSQL_ROOT_PASSWORD=pw my_db
```

### Step 6: Get the Database IP Address
To get the IP address of the running MySQL container, run:

```bash
docker inspect <db_container_id>
```

Find the **IPAddress** in the output and set it as the `DBHOST` variable. For example:

```bash
export DBHOST=172.17.0.2
```

### Step 7: Set Environment Variables
Set the following environment variables for your application:

```bash
export DBHOST=172.17.0.2    # IP of MySQL container
export DBPORT=3306          # MySQL port
export DBUSER=root          # MySQL user
export DATABASE=employees   # Database name
export DBPWD=pw             # MySQL password
export APP_COLOR=blue       # Application color
```

### Step 8: Run the Application
Finally, run the application in a Docker container:

```bash
docker run -p 8080:8080 -e APP_COLOR=$APP_COLOR -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e DBUSER=$DBUSER -e DBPWD=$DBPWD my_app
```

### Step 9: Verify the Application
Visit the application in your browser:

```
http://<Public_IP_ADDRESS>:8080
```

> **Note:** If you are using Cloud9, replace `<Public_IP_ADDRESS>` with the public IP address of your Cloud9 instance.

---

## Troubleshooting

- If the application doesn’t load, check if the MySQL container is running properly.
- Ensure the correct environment variables are set.
- Check Docker logs for any errors:

```bash
docker logs <container_id>
```
### Step 10: AWS ECR Configuration

Once you’ve completed the previous steps, it's time to set up AWS ECR using Terraform.

**1. Navigate to the Terraform directory**:  
Go to the `terraform/` directory where the `.tf` files are located:

```bash
cd terraform/
```

**2. Analyze the `.tf` Files**:  
Open and review each Terraform file (`*.tf`). I’ve added comments to each line of code to help you understand what each part does.  
You can change the names of resources to your preference, as well as modify variable names and prefixes accordingly.

**3. Modify S3 Bucket Name**:  
Don’t forget to add your own S3 bucket name in the `config.tf` file. This is important for the correct configuration of your resources.

**4. Generate SSH Key**:  
Next, generate an SSH key pair to be used in your AWS instance creation. Run the following command:

```bash
ssh-keygen -t rsa -f ass1-dev -q -N ""
```
This will create an SSH key without a passphrase.

**5. Initialize Terraform**:  
Now initialize your Terraform configuration:

```bash
alias tf=terraform
tf init
```
If you encounter a backend error, you can reconfigure the initialization:

```bash
terraform init -reconfigure
```
**6. Format and Validate Terraform Files**:  
After initializing, format and validate your Terraform files:

```bash
tf fmt
tf validate
```

**7. Plan and Apply Terraform Changes:**  
To see the changes Terraform will make, run:

```bash
tf plan
```
After reviewing the plan, apply the changes:

```bash
tf apply --auto-approve
```

**8. Verify Resources in AWS**:  
After Terraform has successfully created the resources, you can manually verify them through the AWS CLI or the AWS Management Console.