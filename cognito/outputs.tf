output "todo_user_pool_id" {
  value = aws_cognito_user_pool.todo_user_pool.id
}

output "todo_user_pool_client_id" {
  value = aws_cognito_user_pool_client.todo_user_pool_client.id
}

output "todo_cognito_user_pool_name" {
  value = aws_cognito_user_pool.todo_user_pool.name
}

output "todo_cognito_user_pool_arn" {
  value = aws_cognito_user_pool.todo_user_pool.arn
}
