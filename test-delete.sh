API_ID="$(terraform output -raw todo_api_gw_id)"
AWS_REGION="$(terraform output -raw todo_aws_region)"
API_URL="https://${API_ID}.execute-api.${AWS_REGION}.amazonaws.com"
echo ${API_URL}/DEV/delete todoId ${TODO_ID_LAST}

curl -H "Authorization: Bearer ${TEST_TOKEN}" \
  -X DELETE ${API_URL}/DEV/delete \
  -d "{\"todoId\": \"${TODO_ID_LAST}\"}"
