resource "aws_dynamodb_table" "todo_table" {
 name = "todo-table"
 billing_mode = "PROVISIONED"
 read_capacity= "30"
 write_capacity= "30"
 attribute {
  name = "id"
  type = "S"
 }
 hash_key = "id"
}
