USER_POOL_ID="$(terraform output -raw todo_user_pool_id)"
USER_NAME=testaus

aws cognito-idp admin-get-user \
  --user-pool-id ${USER_POOL_ID} \
  --username ${USER_NAME}