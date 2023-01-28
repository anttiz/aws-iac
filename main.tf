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
}

module "todo_api" {
  source                           = "./api-gateway"
  cognito_user_arn                 = module.todo_cognito.todo_cognito_user_pool_arn
  api_status_response              = ["200", "500"]
  aws_region                       = var.aws_region
  account_id                       = var.account_id
  dynamodb_table_arn               = module.todo_dynamo.todo_table_arn
  create_todo_lambda_invoke_arn    = module.todo_lambdas.create_todo_lambda_invoke_arn
  create_todo_lambda_function_name = module.todo_lambdas.create_todo_lambda_function_name
  delete_todo_lambda_invoke_arn    = module.todo_lambdas.delete_todo_lambda_invoke_arn
  delete_todo_lambda_function_name = module.todo_lambdas.delete_todo_lambda_function_name
  get_todos_lambda_invoke_arn    = module.todo_lambdas.get_todos_lambda_invoke_arn
  get_todos_lambda_function_name = module.todo_lambdas.get_todos_lambda_function_name
}
