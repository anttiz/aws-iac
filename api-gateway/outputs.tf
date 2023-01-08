output "todo_api_url" {
   value = aws_api_gateway_integration.todo_api_integration.uri
 }

output "todo_api_gw_id" {
   value = aws_api_gateway_rest_api.rest_api.id
 }
