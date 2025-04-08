output "db_password" {
    value       = random_password.master_password.result
    sensitive   = true
    description = "The password for the database administrator user"
}

output "db_endpoint" {
    value       = aws_db_instance.postgres.endpoint
    description = "The database connection endpoint"
}

output "db_username" {
    value       = aws_db_instance.postgres.username
    description = "The username of the database administrator"
}
