USER_POOL_ID="$(terraform output -raw todo_user_pool_id)"
CLIENT_ID="$(terraform output -raw todo_user_pool_client_id)"
USER_NAME=testaus
PASSWORD=passi3_U

aws cognito-idp initiate-auth \
 --client-id ${CLIENT_ID} \
 --auth-flow USER_PASSWORD_AUTH \
 --auth-parameters USERNAME=${USER_NAME},PASSWORD=${PASSWORD} \
 --query 'AuthenticationResult.IdToken' \
 --output text
