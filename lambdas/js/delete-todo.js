const AWS = require("aws-sdk");
const TODO_TABLE = process.env.TODO_TABLE;

const documentClient = new AWS.DynamoDB.DocumentClient();

module.exports.handler = async (event, context) => {
  console.log('2 got event body', event.body, typeof event.body);
  const todoId = event.body.todoId;
  await documentClient
    .delete({
      TableName: TODO_TABLE,
      Key: {
        todoId,
      },
    })
    .promise();

  return {
    statusCode: 200,
    body: JSON.stringify({ message: "Item Deleted" }),
  };
};
