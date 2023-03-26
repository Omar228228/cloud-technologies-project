const AWS = require("aws-sdk");
const region = process.env.aws_region;
const tableName = process.env.table_name;

const dynamodb = new AWS.DynamoDB({
  region: region,
  apiVersion: "2012-08-10"
});

exports.handler = (event, context, callback) => {
  const params = {
    Key: {
      Id: {
        S: event.id
      }
    },
    TableName: tableName
  };
  dynamodb.deleteItem(params, (err, data) => {
    if (err) {
      console.log(err);
      callback(err);
    } else {
      callback(null, data);
    }
  });
};
