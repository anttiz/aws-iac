API_ID="$(terraform output -raw todo_api_gw_id)"
API_URL="https://${API_ID}.execute-api.eu-west-1.amazonaws.com"
echo ${API_URL}/DEV/todo

curl -H "Authorization: Bearer ${TEST_TOKEN}" ${API_URL}/DEV/todo
