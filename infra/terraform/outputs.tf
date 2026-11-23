output "load_balancer_dns_name" {
  description = "Public DNS name of the load balancer"
  value       = aws_lb.main.dns_name
}

output "database_endpoint" {
  description = "Private endpoint of the MySQL database"
  value       = aws_db_instance.main.endpoint
}

output "backup_bucket" {
  description = "Name of the backup bucket"
  value       = aws_s3_bucket.backups.id
}
