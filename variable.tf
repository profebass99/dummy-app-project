variable "cidr_block" {
  type = list(any)
}
variable "availability_zone" {
  type = list(any)
}
variable "default_routes" {
  type = list(any)
}
variable "my_local_isp_public_ip" {
  type = list(any)
}
variable "eice_security_group_name" {}
variable "rds_engine_version" {}
variable "rds_engine" {}
variable "ec2_keypair_name" {}
variable "ec2_instance_type" {}
variable "image_id" {}
variable "ssl_certificate_arn" {}
variable "database_subnet_group_name" {}
variable "instance_tenancy" {}
variable "environment-prefix" {}
variable "default_route" {}
variable "ssh_security_group_name" {}
variable "alb_security_group_name" {}
variable "webserver_security_group_name" {}
variable "database_security_group_name" {}
variable "database_instance_class" {}
variable "database_instance_identifier" {}
variable "target_group_name" {}
variable "alb_name" {}
variable "sns_topic_name" {}
variable "sns_protocol" {}
variable "operator_email" {}
variable "route_53_hosted_zone_name" {}
variable "route_53_record_name" {}
variable "webserver_asg_notifications_group" {}
variable "project_name" {}
variable "aws_iam_instance_profile_name" {}
variable "rds_db_secret_credentials" {}