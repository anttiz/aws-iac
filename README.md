# aws-iac
Terraform creation of AWS API Gateway, Lambda, Cognito

### Instructions
- install Node modules in util_layer/nodejs with command `npm install`
- export AWS profile
- terraform plan
- terraform apply
- create user using command `signup.sh`
- confirm using command `signup_confirm.sh`
- generate token using command `get-token.sh`, export it to env TEST_TOKEN
- test API using command `test-api.sh`
