API_ID="$(terraform output -raw todo_api_gw_id)"
AWS_REGION="$(terraform output -raw todo_aws_region)"
API_URL="https://${API_ID}.execute-api.${AWS_REGION}.amazonaws.com"
echo ${API_URL}/DEV/create

  # -H 'Content-Type: application/json' \
output=$(curl -H "Authorization: Bearer ${TEST_TOKEN}" \
  -X POST ${API_URL}/DEV/create \
  -d "{\"name\": \"Todo1\"}")
echo $output | jq -r '.'
TODO_ID_LAST=$(echo $output | jq -r '.todoId')
echo $TODO_ID_LAST
export TODO_ID_LAST
