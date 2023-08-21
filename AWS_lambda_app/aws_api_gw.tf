resource "aws_api_gateway_rest_api" "lambda-gw" {
  name        = "${var.lambda_name}-lambda-gw-api"
}

resource "aws_api_gateway_resource" "lambda-proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.lambda-gw.id}"
  parent_id   = "${aws_api_gateway_rest_api.lambda-gw.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "lambda-proxy" {
  rest_api_id   = "${aws_api_gateway_rest_api.lambda-gw.id}"
  resource_id   = "${aws_api_gateway_resource.lambda-proxy.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.lambda-gw.id}"
  resource_id = "${aws_api_gateway_method.lambda-proxy.resource_id}"
  http_method = "${aws_api_gateway_method.lambda-proxy.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.lambda.invoke_arn}"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.function_name}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.lambda-gw.execution_arn}/*/*"
}