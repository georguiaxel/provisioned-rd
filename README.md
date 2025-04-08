
# RDS PostgreSQL Infrastructure with Terraform

This project contains the Terraform configuration to provision an RDS PostgreSQL instance on AWS.

## Prerequisites

1. [Terraform](https://www.terraform.io/downloads.html) installed (version 1.0.0 or higher)
2. [AWS CLI](https://aws.amazon.com/cli/) installed and configured
3. AWS credentials configured with the necessary permissions
4. Existing subnets in an AWS VPC

## Project Structure

```
.
├── README.md
└── infra/
   └── environments/
      └── dev/
         ├── main.tf
         └── variables.tf
```

## Resources Created

The configuration creates the following resources on AWS:

- An RDS PostgreSQL instance
- A security group for the database
- A subnet group for the database
- A secure random password for the admin user

## Configuration

Before applying the configuration, you need to:

1. Update the subnet IDs in `main.tf`:
   ```hcl
   subnet_ids = ["subnet-12345678", "subnet-87654321"]  # Replace with your subnet IDs
   ```

2. (Optional) Adjust the database parameters according to your needs:
   - Storage size
   - Instance class
   - Backup window
   - Maintenance window

## Usage

1. Initialize Terraform:
   ```bash
   cd infra/environments/dev
   terraform init
   ```

2. Review the planned changes:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

4. Confirm the application by typing `yes` when prompted.

## Configuration Details

- **Database Engine**: PostgreSQL 14.7
- **Instance Class**: db.t3.micro (modify as needed)
- **Storage**: 20GB GP2 (modify as needed)
- **Backup**: 7-day retention
- **Backup Window**: 03:00-04:00 UTC
- **Maintenance Window**: Monday 04:00-05:00 UTC
- **Public Access**: Disabled
- **Multi-AZ**: Disabled (enable for production)

## Database Access

The database is created with the following parameters:
- **Database Name**: myappdb
- **User**: dbadmin
- **Password**: Automatically generated and securely stored

To retrieve the password, you can use the command:
```bash
terraform output db_password
```

## Cleanup

To delete all created resources:
```bash
terraform destroy
```

## Security Considerations

- The current configuration allows access from any IP (0.0.0.0/0) to port 5432. In a production environment, you should restrict this to specific IPs.
- Consider enabling encryption in transit and at rest for production environments.
- Enable Multi-AZ for high availability in production environments.
- Adjust backup parameters according to your recovery needs.

