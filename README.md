# aws-iac
Terraform creation of AWS API Gateway, Lambda, Cognito

### Instructions
- install Node modules in util_layer/nodejs with command `npm install`
- export AWS profile
- terraform plan
- terraform apply
- create user using command `signup.sh`
- confirm using command `signup-confirm.sh`
- generate token using command `source get-token.sh`, that exports it to env TEST_TOKEN
- test API using command `test-todo.sh`
- test create API using command `test-create.sh`
