resource "aws_iam_role" "sagemaker-observer_lambda_role" {
  name = "sagemaker-observer_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
data "aws_iam_policy_document" "sagemaker-observer_lambda_policy_doc" {
  statement {
    sid = "1"

    actions = [
      "sagemaker:StopNotebookInstance",
      "sagemaker:ListNotebookInstances"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "logs:CreateLogStream"
    ]

    resources = [
      "*",
    ]
  }
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
}
resource "aws_iam_role_policy" "sagemaker-observer_lambda_policy_doc" {
  name = "sagemaker-observer_lambda-policy"
  role = "${aws_iam_role.sagemaker-observer_lambda_role.name}"

  policy = "${data.aws_iam_policy_document.sagemaker-observer_lambda_policy_doc.json}"
}

