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
  dynamodb.getItem(params, (err, data) => {
    if (err) {
      console.log(err);
      callback(err);
    } else {
      callback(null, {
        id: data.Item.Id.S,
        title: data.Item.title.S,
        watchHref: data.Item.watchHref.S,
        authorId: data.Item.authorId.S,
        length: data.Item.length.S,
        category: data.Item.category.S
      });
    }
  });
};
