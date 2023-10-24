# create database subnet group
# terraform aws db subnet group
resource "aws_db_subnet_group" "database_subnet_group" {
  name        = var.database_subnet_group_name
  subnet_ids  = [aws_subnet.private_data_subnet_az1.id, aws_subnet.private_data_subnet_az2.id]
  description = "subnets for database instance"

  tags = {
    Name = "${var.environment-prefix}-database"
  }
}

# create the rds instance
resource "aws_db_instance" "database_instance" {
  engine                 = var.rds_engine
  engine_version         = var.rds_engine_version
  multi_az               = false
  identifier             = var.database_instance_identifier
  username               = local.database_credentials.username
  password               = local.database_credentials.password
  db_name                = local.database_credentials.databasename
  instance_class         = var.database_instance_class
  allocated_storage      = 200
  db_subnet_group_name   = aws_db_subnet_group.database_subnet_group.id
  vpc_security_group_ids = [aws_security_group.database_security_group.id]
  availability_zone      = var.availability_zone[1]
  skip_final_snapshot    = true
  publicly_accessible    = false
}

# # create database instance restored from db snapshots
# # terraform aws db instance
# resource "aws_db_instance" "database_instance" {
#   instance_class         = var.database_instance_class
#   skip_final_snapshot    = true
#   availability_zone      = var.availability_zone[1]
#   identifier             = var.database_instance_identifier
#   snapshot_identifier    = data.aws_db_snapshot.latest_db_snapshot.id
#   db_subnet_group_name   = aws_db_subnet_group.database_subnet_group.name
#   multi_az               = false
#   vpc_security_group_ids = [aws_security_group.database_security_group.id]
# }

# get the latest db snapshot
# terraform aws data db snapshot
# data "aws_db_snapshot" "latest_db_snapshot" {
#   db_snapshot_identifier = var.rds_snapshot_identifier
#   most_recent            = true
#   snapshot_type          = "manual"
# }