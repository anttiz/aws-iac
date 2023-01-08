CLIENT_ID="$(terraform output -raw todo_user_pool_client_id)"
EMAIL="$(terraform output -raw todo_email)"
TEST_USER="$(terraform output -raw todo_username)"
TEST_PASS="$(terraform output -raw todo_password)"

aws cognito-idp sign-up \
 --client-id ${CLIENT_ID} \
 --username ${TEST_USER} \
 --password ${TEST_PASS} \
 --user-attributes Name=name,Value=${NAME} Name=email,Value=${EMAIL}
