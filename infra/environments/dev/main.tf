
provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "postgres" {
  name        = "postgres_rds"
  description = "Security group for PostgreSQL RDS instance"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
  subnet_ids = ["subnet-12345678", "subnet-87654321"]  

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
  engine_version      = "14.7"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  storage_type        = "gp2"
  
  db_name             = "myappdb"
  username           = "dbadmin"
  password           = random_password.master_password.result
  
  db_subnet_group_name   = aws_db_subnet_group.postgres.name
  vpc_security_group_ids = [aws_security_group.postgres.id]
  
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "Mon:04:00-Mon:05:00"
  
  multi_az               = false
  publicly_accessible    = false
  
  skip_final_snapshot    = true

  tags = {
    Environment = "dev"
  }
}
