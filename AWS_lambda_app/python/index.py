def lambda_handler(event, context):
   message = 'Hello!'
   return {
  "statusCode":200,
  "headers":{
    "Content-Type":"text/html; charset=utf-8"
  },
  "body":message
   }