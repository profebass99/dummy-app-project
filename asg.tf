# create a launch template
# terraform aws launch template
resource "aws_launch_template" "webserver_launch_template" {
  name                   = "${var.environment-prefix}-launch-template"
  image_id               = var.image_id
  instance_type          = var.ec2_instance_type
  key_name               = var.ec2_keypair_name
  description            = "launch template for ASG"
  update_default_version = true
  vpc_security_group_ids = [aws_security_group.webserver_security_group.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.s3_full_access_instance_profile.name
  }

  monitoring {
    enabled = true
  }

  user_data = base64encode(templatefile("${path.module}/install-and-configure-nest-app.sh.tpl", {
    PROJECT_NAME = var.project_name
    ENVIRONMENT  = var.environment-prefix
    RECORD_NAME  = var.route_53_record_name
    RDS_ENDPOINT = aws_db_instance.database_instance.endpoint
    RDS_DB_NAME  = local.database_credentials.databasename
    USERNAME     = local.database_credentials.username
    PASSWORD     = local.database_credentials.password
  }))


}

# create auto scaling group
# terraform aws autoscaling group
resource "aws_autoscaling_group" "auto_scaling_group" {
  vpc_zone_identifier = [aws_subnet.private_app_subnet_az1.id, aws_subnet.private_app_subnet_az2.id]
  desired_capacity    = 2
  max_size            = 4
  min_size            = 1
  name                = "${var.environment-prefix}-asg"
  health_check_type   = "ELB"
  depends_on          = [aws_db_instance.database_instance]

  launch_template {
    name    = aws_launch_template.webserver_launch_template.name
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.environment-prefix}-webserver-asg"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [target_group_arns]
  }
}

# attach auto scaling group to alb target group
# terraform aws autoscaling attachment
resource "aws_autoscaling_attachment" "asg_alb_target_group_attachment" {
  autoscaling_group_name = aws_autoscaling_group.auto_scaling_group.id
  lb_target_group_arn    = aws_lb_target_group.alb_target_group.arn
}

# create an auto scaling group notification
# terraform aws autoscaling notification
resource "aws_autoscaling_notification" "webserver_asg_notifications" {
  group_names = [aws_autoscaling_group.auto_scaling_group.name]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.user_updates.arn
}