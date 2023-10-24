# create security group for the ec2 instance connect endpoint
resource "aws_security_group" "eice_security_group" {
  name        = var.eice_security_group_name
  description = "enable outbound traffic on port 22 from the vpc cidr"
  vpc_id      = aws_vpc.terraform_vpc.id

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block[0]]
  }

  tags = {
    Name = "${var.environment-prefix}-eice-security-group"
  }
}

# create security group for the application load balancer
# terraform aws create security group
resource "aws_security_group" "alb_security_group" {
  name        = var.alb_security_group_name
  description = "enable http/https access on port 80/443"
  vpc_id      = aws_vpc.terraform_vpc.id

  ingress {
    description = "http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.default_routes[0]]
  }

  ingress {
    description = "https access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.default_routes[0]]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [var.default_routes[0]]
  }

  tags = {
    Name = "${var.environment-prefix}-ALB-security-group"
  }
}

# create security group for the bastion host aka jump box
# terraform aws create security group
resource "aws_security_group" "ssh_security_group" {
  name        = var.ssh_security_group_name
  description = "enable ssh access on port 22"
  vpc_id      = aws_vpc.terraform_vpc.id

  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_local_isp_public_ip[0]]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [var.default_routes[0]]
  }

  tags = {
    Name = "${var.environment-prefix}-ssh-security-group"
  }
}

# create security group for the web server
# terraform aws create security group
resource "aws_security_group" "webserver_security_group" {
  name        = var.webserver_security_group_name
  description = "enable http/https access on port 80/443 via alb sg and access on port 22 via ssh sg"
  vpc_id      = aws_vpc.terraform_vpc.id

  ingress {
    description     = "http access"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  ingress {
    description     = "https access"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  ingress {
    description     = "ssh access"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.ssh_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [var.default_routes[0]]
  }

  tags = {
    Name = "${var.environment-prefix}-webserver-security-group"
  }
}

# create security group for the database
# terraform aws create security group
resource "aws_security_group" "database_security_group" {
  name        = var.database_security_group_name
  description = "enable mysql/aurora access on port 3306"
  vpc_id      = aws_vpc.terraform_vpc.id

  ingress {
    description     = "mysql/3306 aurora access"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [var.default_routes[0]]
  }

  tags = {
    Name = "${var.environment-prefix}-database-security-group"
  }
}