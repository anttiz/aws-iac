# aws-iac
Serverless Infrastructure creation for AWS

Terraform creation of REST API: AWS API Gateway, Lambda, Cognito, DynamoDB

### Instructions
- install Node modules in `lambdas/js` with command `npm install`
- export AWS_PROFILE=<profile-name>
- `terraform plan`
- `terraform apply --auto-approve`
- create user using command `signup.sh`
- confirm using command `signup-confirm.sh`
- generate token using command `source get-token.sh`, that exports it to env TEST_TOKEN
- previous commands can be combined by running `source login.sh`
- test create API using command `source test-create.sh`
- delete created item using command `source test-delete.sh`, it uses stored TODO_ID_LAST env
