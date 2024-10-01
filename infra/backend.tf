data "terraform_remote_state" "cloud-infra-api" {
  backend = "s3"
  config = {
    bucket = var.state_file
    key    = "${var.environment}/cloud-infra-api/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "cloud-infra-database" {
  backend = "s3"
  config = {
    bucket = var.state_file
    key    = "${var.environment}/cloud-infra-database/terraform.tfstate"
    region = var.aws_region
  }
}
