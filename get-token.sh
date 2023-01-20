USER_POOL_ID="$(terraform output -raw todo_user_pool_id)"
CLIENT_ID="$(terraform output -raw todo_user_pool_client_id)"
TEST_USER="$(terraform output -raw todo_username)"
TEST_PASS="$(terraform output -raw todo_password)"

TEST_TOKEN=`aws cognito-idp initiate-auth \
 --client-id ${CLIENT_ID} \
 --auth-flow USER_PASSWORD_AUTH \
 --auth-parameters USERNAME=${TEST_USER},PASSWORD=${TEST_PASS} \
 --query 'AuthenticationResult.IdToken' \
 --output text`
export TEST_TOKEN
