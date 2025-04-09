# Configuration Parameters for PostgreSQL RDS Instance

This table outlines the parameters you need to replace when configuring your PostgreSQL RDS instance. Customize the values based on your specific environment and requirements.

| **Parameter**                 | **Description**                                                                                                                                           | **Action**                                                                                         | **Example**                          |
|-------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------|--------------------------------------|
| **`db_instance_identifier`**   | Unique identifier for the RDS instance.                                                                                                                    | Replace with a unique name for your PostgreSQL RDS instance.                                         | `"my-db-postgresql"`                |
| **`db_name`**                  | Name of the PostgreSQL database to be created.                                                                                                             | Replace with the desired name for your PostgreSQL database.                                          | `"my_database"`                     |
| **`engine`**                   | Specifies the database engine to use.                                                                                                                      | Set to `"postgres"` for PostgreSQL, or change if using a different database engine (e.g., `"mysql"`).| `"postgres"`                         |
| **`engine_version`**           | Version of the database engine.                                                                                                                            | Replace with the version of PostgreSQL you want to use.                                              | `"13.3"`                             |
| **`db_instance_class`**        | The instance class (size) for the RDS instance.                                                                                                           | Choose an instance class based on your performance requirements (e.g., `"db.t3.micro"`, `"db.m5.large"`). | `"db.t3.micro"`                      |
| **`allocated_storage`**        | Amount of storage to allocate for the RDS instance in gigabytes (GB).                                                                                     | Adjust the value based on your expected storage needs.                                               | `20`                                 |
| **`db_subnet_group_name`**     | The DB subnet group name to use for the instance.                                                                                                         | Replace with the subnet group that you want to associate with your RDS instance.                     | `"my-subnet-group"`                  |
| **`vpc_security_group_ids`**   | List of VPC security group IDs for controlling access to the RDS instance.                                                                                | Replace with the security group IDs of your VPC.                                                     | `- "sg-xxxxxxxxxxxxxxxxx"`           |
| **`availability_zone`**        | The availability zone in which the RDS instance will be created.                                                                                          | Choose the availability zone that fits your needs, or leave as AWS default.                         | `"us-east-1a"`                       |
| **`master_username`**          | Master username for the RDS instance.                                                                                                                     | Replace with the desired master username.                                                          | `"dbadmin"`                          |
| **`master_user_password`**     | Master password for the RDS instance.                                                                                                                     | Replace with a secure and strong password.                                                          | `"supersecret123"`                   |
| **`region`**                   | AWS region where the RDS instance will be created.                                                                                                        | Replace with your AWS region (e.g., `"us-west-2"`, `"eu-west-1"`).                                  | `"us-east-1"`                        |
| **`state`**                    | The desired state of the RDS instance.                                                                                                                     | Set to `"present"` to create the instance, or `"absent"` to delete it.                             | `"present"`                          |

# Requirements for Creating a PostgreSQL RDS Instance Using Ansible

```bash
# System Requirements

# Operating System: Linux/macOS (Windows users may need WSL or Git Bash)
# Python Version: Ensure Python 3.x is installed
python3 --version

# AWS CLI: Ensure it is installed and configured
aws --version

# Ansible: Ensure it is installed
ansible --version

# AWS Requirements
# Ensure you have an active AWS account.

# The user must have permissions for RDS, EC2, and networking resources:
# AmazonRDSFullAccess, AmazonVPCFullAccess

# Ensure that you have at least two subnets in different Availability Zones for RDS.
# AWS Access & Secret Keys: Needed for authentication
aws configure

```

# Software & Dependencies

| Dependency                      | Description                                      | Installation Command                                  |
|----------------------------------|--------------------------------------------------|------------------------------------------------------|
| **Python 3**                     | Required for virtual environment & Ansible      | `sudo apt install python3` (Linux) or use Homebrew (Mac) |
| **Pip**                           | Python package manager                          | `sudo apt install python3-pip` or `brew install pip` |
| **Virtualenv**                    | Create isolated Python environments             | `pip install virtualenv` |
| **AWS CLI**                       | Interface to interact with AWS services         | `pip install awscli` |
| **Boto3**                         | Python SDK for AWS                              | `pip install boto3 botocore` |
| **Ansible**                       | Automation tool for provisioning infrastructure | `pip install ansible` |
| **Amazon AWS Ansible Collection**  | Required to interact with AWS services         | `ansible-galaxy collection install amazon.aws` |


# Steps to Execute the Ansible Playbook for AWS RDS

Follow these steps to set up and execute the Ansible playbook for provisioning an AWS RDS instance.
### Create a Python Virtual Environment
Create an isolated Python environment to manage dependencies.

```bash
python3 -m venv venv
```
### Activate the Virtual Environment
Activate the virtual environment to use its isolated dependencies.

```bash
source venv/bin/activate
```
### Install Required Python Packages
Install the necessary Python packages for AWS CLI and Boto3.

```bash
pip install awscli botocore
```
### Verify AWS CLI Installation
Ensure that the AWS CLI is installed correctly by checking its version.

```bash
aws --version
```
### Install Ansible and AWS Collection
Install Ansible and the Amazon AWS Ansible collection to enable interaction with AWS services.

```bash
ansible-galaxy collection install amazon.aws
```
### Configure AWS CLI
Set up the AWS CLI with your credentials and default region.

```bash
aws configure
```
### Create an RDS Subnet Group
Create a subnet group for your RDS instance. Replace `<your-subnet-group-name>`, `<subnet-id-1>`, and `<subnet-id-2>` with your specific values.

```bash
aws rds create-db-subnet-group --db-subnet-group-name <your-subnet-group-name> \
--db-subnet-group-description "Description of your subnet group" \
--subnet-ids <subnet-id-1> <subnet-id-2>
```
### (Optional) Describe Subnets
List the subnets in your AWS account to verify their IDs.

```bash
aws ec2 describe-subnets --query 'Subnets[*].SubnetId'
```
### Describe Availability Zones
Check the availability zones in your AWS region. Replace `<your-region>` with your desired AWS region.

```bash
aws ec2 describe-availability-zones --region <your-region>
```
### Run the Ansible Playbook
Execute the Ansible playbook to provision the RDS instance. Ensure that `rds_playbook.yml` is properly configured.

```bash
ansible-playbook -i localhost, -c local rds_playbook.yml
```
### Notes:
- Ensure you have the necessary AWS permissions (e.g., `AmazonRDSFullAccess`, `AmazonVPCFullAccess`).
- Verify that you have at least two subnets in different availability zones for RDS.
- Use secure credentials and follow best practices for managing AWS access keys.
