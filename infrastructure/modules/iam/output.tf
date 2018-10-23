

output "sagemaker-observer_lambda_role_id" {
  value = "${aws_iam_role.sagemaker-observer_lambda_role.arn}"
}