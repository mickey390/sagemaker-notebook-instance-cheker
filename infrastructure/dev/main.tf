terraform {
  backend "local" {}
}

provider "aws" {
  region  = "ap-northeast-1"
  version = "~> 1.39.0"
}

provider "template" {
  version = "~> 1.0.0"
}

module "iam" {
  source = "../modules/iam"
}

module "cloudwatch_events" {
  source = "../modules/cloudwatch_events"
 
  aws_region = "${var.aws_region}"
  lambda_function_role_id = "${module.iam.sagemaker-observer_lambda_role_id}"
}