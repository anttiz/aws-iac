API_ID="$(terraform output -raw todo_api_gw_id)"
USERNAME="$(terraform output -raw todo_username)"
PASSWORD="$(terraform output -raw todo_password)"
CLIENT_ID="$(terraform output -raw todo_user_pool_client_id)"
POOL_ID="$(terraform output -raw todo_user_pool_id)"
cat <<EOF
VITE_TODO_USERNAME="$USERNAME"
VITE_TODO_PASSWORD="$PASSWORD"
VITE_TODO_USER_POOL_CLIENT_ID="$CLIENT_ID"
VITE_TODO_USER_POOL_ID="$POOL_ID"
VITE_TODO_ENDPOINT="https://${API_ID}.execute-api.eu-west-1.amazonaws.com/DEV"
EOF
