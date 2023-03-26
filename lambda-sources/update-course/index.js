const AWS = require("aws-sdk");
const region = process.env.aws_region;
const tableName = process.env.table_name;

const dynamodb = new AWS.DynamoDB({
  region: region,
  apiVersion: "2012-08-10"
});

exports.handler = (event, context, callback) => {
  const params = {
    Item: {
      Id: {
        S: event.id
      },
      title: {
        S: event.title
      },
      watchHref: {
        S: event.watchHref
      },
      authorId: {
        S: event.authorId
      },
      length: {
        S: event.length
      },
      category: {
        S: event.category
      }
    },
    TableName: tableName
  };
  dynamodb.putItem(params, (err, data) => {
    if (err) {
      console.log(err);
      callback(err);
    } else {
      callback(null, {
        id: params.Item.Id.S,
        title: params.Item.title.S,
        watchHref: params.Item.watchHref.S,
        authorId: params.Item.authorId.S,
        length: params.Item.length.S,
        category: params.Item.category.S
      });
    }
  });
};
