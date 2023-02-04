const AWS = require("aws-sdk");

const TODO_TABLE = process.env.TODO_TABLE;

const documentClient = new AWS.DynamoDB.DocumentClient();

module.exports.handler = async (event, context) => {
  const allNotes = await documentClient
    .scan({
      TableName: TODO_TABLE,
    })
    .promise();

  const { Items = [] } = allNotes;
  return {
    statusCode: 200,
    body: JSON.stringify(Items),
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Credentials': true
    }
  };
};
