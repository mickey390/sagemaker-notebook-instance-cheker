import json
import boto3
import os
from botocore.vendored import requests
from datetime import datetime as dt
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

client = boto3.client('sagemaker')

# Slack の設定
SLACK_POST_URL = os.environ['SLACK_POST_URL']
SLACK_CHANNEL = os.environ['SLACK_CHANNEL']
SLACK_USERNAME = 'Daily SageMakerNotebook Check'
SLACK_ICON_EMOJI = ':speaking_head_in_silhouette:'

def build_slack_message(text, color="good"):
    '''
    see@https://api.slack.com/docs/message-attachments#attachment_structure
    '''
    atachements = {"text":text,"color":color}
    return atachements

def send_slack(content):
    '''
    slackにcontentを送る
    '''
    slack_message = {
        'icon_emoji': SLACK_ICON_EMOJI,
        'username': SLACK_USERNAME,
        'channel': SLACK_CHANNEL,
        'attachments': [content],
    }

    try:
        req = requests.post(SLACK_POST_URL, data=json.dumps(slack_message))
        logger.info("Message posted to %s", slack_message['channel'])
    except requests.exceptions.RequestException as e:
        logger.error("Request failed: %s", e)
    

def stop_notebook_instance(name):
    '''
    see@https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/sagemaker.html#SageMaker.Client.stop_notebook_instance
    '''
    client.stop_notebook_instance(
        NotebookInstanceName = name
    )

def check_notebook():
    '''
    see@https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/sagemaker.html#SageMaker.Client.stop_notebook_instance
    '''

    # ノートブックインスタンス
    response = client.list_notebook_instances(
        StatusEquals='InService'
        # StatusEquals='Pending'
    )
    res = response["NotebookInstances"]
    
    return res


def lambda_handler(event, context):

    notebook = check_notebook()
    print (notebook)

    if len(notebook) == 0:
        send_slack(build_slack_message("起動中のSagemakerNotebookはありませんでした。")) 
        return

    for v in notebook:
        print ('NotebookInstanceName：{}'.format(v["NotebookInstanceName"])) 
        message = ('NotebookInstanceName：{} が起動中でした。停止リクエストを送りました。\n'.format(v["NotebookInstanceName"]))
        send_slack(build_slack_message(message))
        stop_notebook_instance(v["NotebookInstanceName"])

    return
