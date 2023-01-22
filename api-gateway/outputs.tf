output "todo_api_url" {
   value = aws_api_gateway_integration.create_todo_api_integration.uri
 }

output "todo_api_gw_id" {
   value = aws_api_gateway_rest_api.rest_api.id
 }

output "lambda_exec_arn" {
  value = aws_iam_role.lambda_exec.arn
}
