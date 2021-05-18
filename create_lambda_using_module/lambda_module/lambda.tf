#resource "aws_iam_policy" "lambda_logging" {
#  name        = var.policy_name
#  path        = "/"
#  description = "IAM policy for logging from a lambda"

#  policy = file("${var.policy}")
#}

#resource "aws_iam_role" "iam_for_lambda" {
#  name = var.role_name

#  assume_role_policy = file("${var.trust-advisor}")
#}

#resource "aws_iam_role_policy_attachment" "lambda_logs" {
#  role       = aws_iam_role.iam_for_lambda.name
#  policy_arn = aws_iam_policy.lambda_logging.arn
#  depends_on = [ aws_iam_policy.lambda_logging, aws_iam_role.iam_for_lambda ]
#}

resource "aws_lambda_function" "test_lambda" {
  filename      = var.filename  # "lambda_function_payload.zip"
  function_name = var.function_name #"test_lambda_function"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = var.handler # "lambda_function_payload.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("${var.filename}")
  kms_key_arn = "arn:aws:kms:us-east-2:562086155953:key/5bb3af38-7c46-43a4-9012-133af32fe723"
  
  runtime = var.runtime  # [ "nodejs10.x", "nodejs12.x", "nodejs14.x", "python2.7", "python3.7", "python3.8" ]
  timeout = var.timeout #240
  environment {
    variables = {
      Name = "${var.env_variable1}"
      Test = "${var.env_variable2}"
    }
  }
}
