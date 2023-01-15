const AWS = require("aws-sdk");

const TODO_TABLE = process.env.TODO_TABLE;

const documentClient = new AWS.DynamoDB.DocumentClient();

module.exports.handler = async (event, context) => {
  // create a new object
  console.log("Reached lambda", event);
  const body = event.body;
  const newTodo = {
    ...body,
    id: String(Date.now()),
    expiryPeriod: Date.now(), // specify TTL
  };

  // insert it to the table

  await documentClient
    .put({
      TableName: TODO_TABLE,
      Item: newTodo,
    })
    .promise();

  // return the created object

  return { statusCode: 200, body: JSON.stringify(newTodo) };
};
