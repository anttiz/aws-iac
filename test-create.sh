API_ID="$(terraform output -raw todo_api_gw_id)"
API_URL="https://${API_ID}.execute-api.eu-west-1.amazonaws.com"
echo ${API_URL}/DEV/create

  # -H 'Content-Type: application/json' \

curl -H "Authorization: Bearer ${TEST_TOKEN}" \
  -X POST ${API_URL}/DEV/create \
  -d '{"name": "Todo1"}'

