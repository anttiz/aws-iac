import { DynamoDB } from "aws-sdk";

const TODO_TABLE = process.env.TODO_TABLE;

const documentClient = new DynamoDB.DocumentClient();

export async function handler(event, context) {
  // create a new object

  const body = event.body;
  const newTodo = {
    ...body,
    id: Date.now(),
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
}
