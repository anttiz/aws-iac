USER_POOL_ID="$(terraform output -raw todo_user_pool_id)"
TEST_USER="$(terraform output -raw todo_username)"

aws cognito-idp admin-confirm-sign-up  \
 --user-pool-id ${USER_POOL_ID} \
 --username ${TEST_USER}