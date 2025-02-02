
# **Docker Assignment 1**

## **Introduction**
This mini-project demonstrates how to run an application with MySQL using Docker containers. The guide will walk you through setting up a local environment, building Docker images, deploying the application, and integrating AWS services using Terraform. By the end of this project, you will have a fully functional application running in Docker containers locally and on an AWS EC2 instance using AWS Elastic Container Registry (ECR).

## **Prerequisites**

Fork and clone my repository to follow along.

And before you begin, ensure you have the following installed:
- Docker
- Python 3.x
- `pip` for installing Python dependencies
- Terraform
- AWS CLI

## **Setup Instructions**

### **Step 1: Install Necessary Packages**
First, update your system's package list and install required packages:

```bash
sudo apt-get update -y
```

### **Step 2: Install Python Dependencies**
Install the required Python libraries using `pip`:

```bash
pip3 install -r requirements.txt
```

### **Step 3: Build MySQL Docker Image**
Build the MySQL Docker image:

```bash
docker build -t my_db -f Dockerfile_mysql .
```

### **Step 4: Build Application Docker Image**
Now, build the application Docker image:

```bash
docker build -t my_app -f Dockerfile .
```

### **Step 5: Start MySQL Container**
Run the MySQL Docker container:

```bash
docker run -d -e MYSQL_ROOT_PASSWORD=<REPLACE_WITH_YOUR_PASSWORD> my_db
```

### **Step 6: Get the Database IP Address**
To get the IP address of the running MySQL container, run:

```bash
docker inspect <db_container_id>
```

Locate the **IPAddress** in the output and assign it to the `DBHOST` variable. For example:

```bash
export DBHOST=172.17.0.2
```

### **Step 7: Set Environment Variables**
Set the following environment variables for your application:

```bash
export DBHOST=172.17.0.2    # IP of MySQL container
export DBPORT=3306          # MySQL port
export DBUSER=root          # MySQL user
export DATABASE=employees   # Database name
export DBPWD=<REPLACE_WITH_YOUR_PASSWORD>  # MySQL password
export APP_COLOR=blue       # Application color
```

### **Step 8: Run the Application**
Finally, run the application in a Docker container:

```bash
docker run -p 8080:8080 -e APP_COLOR=$APP_COLOR -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e DBUSER=$DBUSER -e DBPWD=$DBPWD my_app
```

### **Step 9: Verify the Application**
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

### **Step 10: AWS ECR Configuration**

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

### **Step 11: Configure your GitHub workflow**  
After initializing the terraform resources, create a github workflow in your repository by referring to my workflow.  
I have added comments to each line to properly explain each step.  
Do not forget to initialize AWS environment variables for your repository.

### **Step 12: Creating MySQL and Application Containers in EC2**  
Now in this step, you will need to create containers in your newly created EC2 instance by pulling the images from ECR and running the application in your EC2's Docker containers.  

For this, first, check if Docker is installed in your EC2 Instance by running:

```bash
docker --version
```

By default, it should already be installed, as we executed those commands in the user data script (`.sh` file) in Terraform.  

Now, check if AWS CLI version installed and configured:  

```bash
aws --version  
```

**Authenticate Docker to AWS ECR**
```bash
aws ecr get-login-password --region <AWS_REGION> | docker login --username AWS --password-stdin <AWS_ACCOUNT_ID>.dkr.ecr.<AWS_REGION>.amazonaws.com
```

**List and Pull Docker Images**
```bash
aws ecr list-images --repository-name <ECR_REPO_NAME> --region <AWS_REGION>
docker pull <AWS_ACCOUNT_ID>.dkr.ecr.<AWS_REGION>.amazonaws.com/<ECR_REPO_NAME>:<APP_IMAGE_NAME>
docker pull <AWS_ACCOUNT_ID>.dkr.ecr.<AWS_REGION>.amazonaws.com/<ECR_REPO_NAME>:<DB_IMAGE_NAME>
```

**Set up a Custom Docker Network and Run Containers**
```bash
docker network create -d bridge --subnet 10.0.0.0/24 --gateway 10.0.0.1 <NETWORK_NAME>
docker run -d -e MYSQL_ROOT_PASSWORD=<REPLACE_WITH_YOUR_PASSWORD> --name my-db-container --network <NETWORK_NAME> <DB_IMAGE_ID>
docker run -d -p 8081:8080 -e APP_COLOR=blue --network <NETWORK_NAME> --name blue-app <APP_IMAGE_ID>
docker run -d -p 8082:8080 -e APP_COLOR=pink --network <NETWORK_NAME> --name pink-app <APP_IMAGE_ID>
docker run -d -p 8083:8080 -e APP_COLOR=lime --network <NETWORK_NAME> --name lime-app <APP_IMAGE_ID>
```

**Verify your applications at**
```bash
http://<EC2_PUBLIC_IP>:8081
http://<EC2_PUBLIC_IP>:8082
http://<EC2_PUBLIC_IP>:8083
```
Play around with the application

**Access the MySQL container and interact with the database**  

```bash
docker exec -it my-db-container /bin/bash  # Enter the MySQL container shell
mysql -uroot -ppw  # Log into MySQL as root with the password 'pw' or with your custom password
SHOW DATABASES;  # Show all available databases
use employees;  # Switch to the 'employees' database
SHOW TABLES;  # Show all tables in the 'employees' database
DESCRIBE employee;  # Describe the structure of the 'employee' table
SELECT * FROM employee LIMIT 10;  # Retrieve first 10 records from 'employee' table
exit  # Exit MySQL
```

**Test Connectivity between applications**
```bash
docker exec -it blue-app /bin/bash
apt-get update
apt-get install iputils-ping -y
ping pink-app
ping lime-app
exit
```

## **Conclusion**

This project provided a hands-on experience in running applications with Docker, managing MySQL databases in containers, deploying to AWS using Terraform, and integrating GitHub workflows. You now have a better understanding of containerization, cloud deployments, and infrastructure as code.

Happy coding! 🚀
