variable "cognito_user_arn" {}

variable "account_id" {}

variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "eu-west-1"
}

variable "api_status_response" {
  description = "API http status response"
  type = list(object({
    status_code = string
    index       = number
  }))
  default = [{ status_code : "200", index : 0 }, { status_code : "500", index : 0 },
    { status_code : "200", index : 1 }, { status_code : "500", index : 1 },
  { status_code : "200", index : 2 }, { status_code : "500", index : 2 }]
}

variable "dynamodb_table_arn" {
  type = string
}

variable "lambda_invoke_arn" {
  type = list(string)
}

variable "lambda_function_name" {
  type = list(string)
}

variable "lambda_names" {
  type = list(string)
}

variable "paths" {
  type = list(string)
}

variable "methods" {
  type = list(string)
}
