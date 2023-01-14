terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

module "util_layer" {
  source = "./util-layer"
}

module "todo_cognito" {
  source = "./cognito"
}

module "todo_dynamodb" {
  source = "./dynamodb"
}

module "todo_api" {
  source                 = "./api-gateway"
  cognito_user_arn       = module.todo_cognito.todo_cognito_user_pool_arn
  api_status_response    = ["200", "500"]
  aws_region             = var.aws_region
  account_id             = var.account_id
  util_layer_arn_array   = module.util_layer.util_layer_arn_array
}
