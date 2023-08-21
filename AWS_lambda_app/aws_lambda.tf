data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_dir  = "${path.module}/python/"
  output_path = "${path.module}/python/hello-python.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name = "${var.ecs_service_name}-lambda"
  filename         = "${path.module}/python/hello-python.zip"
  role    = aws_iam_role.lambda_role.arn
  handler = "index.lambda_handler"
  runtime = "python3.8"
}