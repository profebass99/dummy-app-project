output "vpc_id" {
  value = aws_vpc.terraform_vpc.id
}

output "public_subnet_az1_id" {
  value = aws_subnet.public_subnet_az1.id
}

output "public_subnet_az2_id" {
  value = aws_subnet.public_subnet_az2.id
}

output "private_app_subnet_az1" {
  value = aws_subnet.private_app_subnet_az1.id
}

output "private_app_subnet_az2" {
  value = aws_subnet.private_app_subnet_az2.id
}


output "website_url" {
  value = join("", ["https://", aws_route53_record.site_domain.name, ".", data.aws_route53_zone.hosted_zone.name])
}

output "hosted_zone" {
  value = data.aws_route53_zone.hosted_zone.name
}