resource "aws_db_subnet_group" "main" {
  name       = "${var.project}-db"
  subnet_ids = aws_subnet.private[*].id
}

resource "aws_db_instance" "main" {
  identifier        = "${var.project}-mysql"
  engine            = "mysql"
  engine_version    = "8.4"
  instance_class    = var.db_instance_class
  allocated_storage = 20
  db_name           = "monitor"
  username          = "monitor_admin"

  # The master password is generated and stored in Secrets Manager, never in the code.
  manage_master_user_password   = true
  master_user_secret_kms_key_id = aws_kms_key.main.arn

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]
  publicly_accessible    = false
  multi_az               = true

  storage_encrypted = true
  kms_key_id        = aws_kms_key.main.arn

  backup_retention_period   = 7
  deletion_protection       = true
  skip_final_snapshot       = false
  final_snapshot_identifier = "${var.project}-mysql-final"
  copy_tags_to_snapshot     = true

  auto_minor_version_upgrade          = true
  iam_database_authentication_enabled = true

  monitoring_interval             = 60
  monitoring_role_arn             = aws_iam_role.rds_monitoring.arn
  performance_insights_enabled    = true
  performance_insights_kms_key_id = aws_kms_key.main.arn
  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]
}
