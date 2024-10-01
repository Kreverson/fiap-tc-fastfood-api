# Acessar o estado remoto do EKS e VPC
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.state_file
    key    = "${var.environment}/eks/vpc/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = var.state_file
    key    = "${var.environment}/eks/terraform.tfstate"
    region = var.aws_region
  }
}

# Acessar o estado remoto do RDS
data "terraform_remote_state" "rds" {
  backend = "s3"
  config = {
    bucket = var.state_file
    key    = "${var.environment}/rds/terraform.tfstate"
    region = var.aws_region
  }
}
