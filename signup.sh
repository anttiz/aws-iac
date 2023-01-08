CLIENT_ID="$(terraform output -raw todo_user_pool_client_id)"
USER_NAME=testaus
PASSWORD=passi3_U
AWS_PROFILE=antti

aws cognito-idp sign-up \
 --client-id ${CLIENT_ID} \
 --username ${USER_NAME} \
 --password ${PASSWORD} \
 --user-attributes Name=name,Value=${NAME} Name=email,Value=${EMAIL}
