variable "cognito_user_arn" {}

variable "util_layer_arn_array" {}

variable "account_id" {}

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

#variable "account_id" {
#  type=string
#  default = "202311884343"
#}