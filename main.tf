terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.20.0"
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

module "todo_cognito" {
  source = "./cognito"
}

module "todo_dynamo" {
  source = "./dynamo-db"
}

module "todo_lambdas" {
  source              = "./lambdas"
  dynamodb_table_name = module.todo_dynamo.todo_table_name
  lambda_exec_arn     = module.todo_api.lambda_exec_arn
  lambda_names        = var.lambda_names
}

module "todo_api" {
  lambda_names     = var.lambda_names
  paths            = var.paths
  methods          = var.methods
  source           = "./api-gateway"
  cognito_user_arn = module.todo_cognito.todo_cognito_user_pool_arn
  api_status_response = flatten([
    for i, v in var.lambda_names : [
      for v2 in var.status_codes :
      { status_code : v2, index : i }
    ]
  ])
  aws_region           = var.aws_region
  account_id           = var.account_id
  dynamodb_table_arn   = module.todo_dynamo.todo_table_arn
  lambda_invoke_arn    = module.todo_lambdas.lambda_invoke_arn
  lambda_function_name = module.todo_lambdas.lambda_function_name
}
