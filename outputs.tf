output "todo_user_pool_id" {
  value = module.todo_cognito.todo_user_pool_id
}

output "todo_user_pool_client_id" {
  value = module.todo_cognito.todo_user_pool_client_id
}

output "todo_api_url" {
  value = module.todo_api.todo_api_url
}

output "todo_api_gw_id" {
  value = module.todo_api.todo_api_gw_id
}

output "todo_username" {
  value=var.todo_username
}

output "todo_password" {
  value=var.todo_password
}

output "todo_email" {
  value=var.todo_email
}
