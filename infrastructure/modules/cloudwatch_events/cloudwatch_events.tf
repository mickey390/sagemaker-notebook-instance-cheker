data "aws_caller_identity" "current" {}

resource "aws_cloudwatch_event_rule" "lambda" {
  name        = "apex-sagemaker-notebook-stopper"
  description = "apex sagemaker notebook stopper"
  schedule_expression = "cron(0 17 * * ? *)"
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule      = "${aws_cloudwatch_event_rule.lambda.name}"
  target_id = "apex-sagemaker-notebook-stopper"
  arn       = "arn:aws:lambda:${var.aws_region}:${data.aws_caller_identity.current.account_id}:function:sagemaker-observer_notebook-instance-stopper"
}
 
resource "aws_lambda_permission" "lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_cloudwatch_event_target.lambda.arn}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.lambda.arn}"
}