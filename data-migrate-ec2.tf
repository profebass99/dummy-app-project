data "aws_secretsmanager_secret_version" "secret_manager_credentials" {
  secret_id = var.rds_db_secret_credentials
}

locals {
  database_credentials = jsondecode(
    data.aws_secretsmanager_secret_version.secret_manager_credentials.secret_string
  )
}


resource "aws_instance" "data_migrate_ec2" {
  ami                    = var.image_id
  instance_type          = var.ec2_instance_type
  subnet_id              = aws_subnet.private_app_subnet_az1.id
  vpc_security_group_ids = [aws_security_group.webserver_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.s3_full_access_instance_profile.name

  user_data = base64encode(templatefile("${path.module}/migrate-nest-sql.sh.tpl", {
    RDS_ENDPOINT = aws_db_instance.database_instance.endpoint
    RDS_DB_NAME  = local.database_credentials.databasename
    USERNAME     = local.database_credentials.username
    PASSWORD     = local.database_credentials.password
  }))

  depends_on = [aws_db_instance.database_instance]

  tags = {
    Name = "${var.environment-prefix}-data-migration-instance"
  }
}


