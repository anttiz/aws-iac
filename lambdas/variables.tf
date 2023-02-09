variable "dynamodb_table_name" {
  type = string
}

variable "lambda_exec_arn" {
  type = string
}

variable "lambda_names" {
  type = list(string)
}
