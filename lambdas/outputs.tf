output "todo_lambda_invoke_arn" {
  value = aws_lambda_function.lambda_todo.invoke_arn
}

output "todo_lambda_function_name" {
  value = aws_lambda_function.lambda_todo.function_name
}

output "create_todo_lambda_invoke_arn" {
  value = aws_lambda_function.lambda_create_todo.invoke_arn
}

output "create_todo_lambda_function_name" {
  value = aws_lambda_function.lambda_create_todo.function_name
}