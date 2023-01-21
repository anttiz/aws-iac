# Input variable definitions

variable "aws_region" {
  description = "AWS region for all resources."
  type    = string
  default = "eu-west-1"
}

variable "api_status_response" {
  description = "API http status response"
  type        = list(string)
  default = [ "200", "500" ]
}

variable "account_id" {
  type=string
  default = "202311884343"
}

variable "todo_username" {
  type=string
  default = "todo"
}

variable "todo_password" {
  type=string
  default = "todo1U$"
}

variable "todo_email" {
  type=string
  default="testaaja@abc.com"
}
