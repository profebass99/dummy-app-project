provider "aws" {
  region  = "us-east-1"
  profile = "terraform-user"
}

terraform {
  backend "s3" {
    bucket  = "terraform-statefile-backend-useast1"
    key     = "aos/terraform.tfstate.dev"
    region  = "us-east-1"
    profile = "terraform-user"
  }
}
