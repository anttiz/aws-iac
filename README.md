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
- previos commands can be combined by running `source login.sh`
- test create API using command `source test-create.sh`
- delete created item using command `source test-delete.sh`, it uses stored TODO_ID_LAST env
