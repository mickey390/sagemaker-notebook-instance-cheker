# 初期設定

## Slack通知用の設定を記載

```
cd /project/root/
vi env.json
{
    "SLACK_CHANNEL": "your_channel",
    "SLACK_POST_URL": "your_post_url"
}
```

## lambdaのroleに自身のAWS_ACCOUNT_IDを設定

```
AWS_ACCOUNT_ID=$(aws sts get-caller-identity | jq -r '.Account')

sed -i '' -e "s/YOUR_AWS_ACCOUNT_ID/${AWS_ACCOUNT_ID}/g" project.json
```

# Lambda用のIAMの作成

```
# create symlink
apex infra get
# check
apex infra plan -target=module.iam
# apply
apex infra apply -target=module.iam
```

# Lambda Functionをデプロイ

```
apex deploy -E env.json notebook-instance-stopper
```

# cloudwatch eventの作成

```
# check
apex infra plan
# apply
apex infra apply
```

[Schedule Expressions for Rules - Amazon CloudWatch Events](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html#CronExpressions)