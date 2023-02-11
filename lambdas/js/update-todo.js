const AWS = require("aws-sdk");

const TODO_TABLE = process.env.TODO_TABLE;

const documentClient = new AWS.DynamoDB.DocumentClient();

module.exports.handler = async (event, context) => {
  const body = JSON.parse(event.body);
  const newTodo = {
    ...body,
  };
  if (!newTodo.todoId) {
    // for a new object, add id
    newTodo.todoId = String(Date.now());
    newTodo.expiryPeriod = Date.now();
  }
  // insert it to the table
  const result = await documentClient
    .put({
      TableName: TODO_TABLE,
      Item: newTodo,
    })
    .promise();

  // return the created object
  return {
    statusCode: 200,
    body: JSON.stringify(newTodo),
    headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": true,
    },
  };
};
