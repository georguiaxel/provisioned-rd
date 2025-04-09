
provider "aws" {
  region = "us-east-1"  # TODO: Change if deploying in another region
}

resource "aws_security_group" "postgres" {
  name        = "postgres_rds"
  description = "Security group for PostgreSQL RDS instance"
  
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # TODO: Replace with your public IP for security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  tags = {
    Name = "postgres_rds"
  }
}

resource "aws_db_subnet_group" "postgres" {
  name       = "postgres_subnet_group"
  subnet_ids = local.subnet_ids  

  tags = {
    Name = "PostgreSQL DB subnet group"
  }
}

resource "random_password" "master_password" {
  length  = 16
  special = true
}

resource "aws_db_instance" "postgres" {
  identifier           = "postgresql-instance"
  engine              = "postgres"
  engine_version      = "11.22"  # TODO: Verify latest PostgreSQL version
  instance_class      = "db.t3.micro"  # TODO: Change based on required performance
  allocated_storage   = 20  # TODO: Adjust storage as needed
  storage_type        = "gp2"
  
  db_name             = "myappdb"  # TODO: Change if a different database name is needed
  username           = "dbadmin"  # TODO: Change username if necessary
  password           = random_password.master_password.result
  
  db_subnet_group_name   = aws_db_subnet_group.postgres.name
  vpc_security_group_ids = [aws_security_group.postgres.id]
  
  backup_retention_period = 7  # TODO: Adjust backup settings if needed
  backup_window          = "03:00-04:00"
  maintenance_window     = "Mon:04:00-Mon:05:00"
  
  multi_az               = false  # TODO: Set to true for high availability
  publicly_accessible    = false  # TODO: Change to true only if external access is needed
  
  skip_final_snapshot    = true

  tags = {
    Environment = "dev"  # TODO: Change to match the deployment environment (e.g., staging, production)
  }
}