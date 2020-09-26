import logging
import os

from flask import Flask, abort, request
from google.cloud import secretmanager
from linebot import LineBotApi, WebhookHandler
from linebot.exceptions import InvalidSignatureError
from linebot.models import MessageEvent, TextMessage, TextSendMessage


def kms_secret(secret_id, version_id):
    """
    Access the payload for the given secret version if one exists. The version
    can be a version number as a string (e.g. "5") or an alias (e.g. "latest").
    """

    project_id = os.getenv('PROJECT_ID')
    name = f"projects/{project_id}/secrets/{secret_id}/versions/{version_id}"

    # Access the secret version
    client = secretmanager.SecretManagerServiceClient()
    response = client.access_secret_version(request={'name': name})

    return response.payload.data.decode('UTF-8')


def env_secret(key):
    return os.getenv(key)


def secret(secret_key):
    if os.getenv('SECRET_TYPE') == 'KMS':
        return kms_secret(secret_id=kms_secret, version_id='latest')
    else:
        return env_secret(key=secret_key)


app = Flask(__name__)
app.logger.setLevel(logging.INFO)
handler = WebhookHandler(secret('CHANNEL_SECRET'))
line_bot_api = LineBotApi(secret('CHANNEL_ACCESS_TOKEN'))


@app.route('/health', methods=['GET'])
def health():
    return 'OK'


@app.route('/callback', methods=['POST'])
def callback():
    signature = request.headers['X-Line-Signature']
    body = request.get_data(as_text=True)
    app.logger.debug("Request body: " + body)
    try:
        handler.handle(body, signature)
    except InvalidSignatureError:
        app.logger.warn('Invalid signature. Please check your channel access token/channel secret.')
        abort(400)

    return 'OK'


@handler.add(MessageEvent, message=TextMessage)
def handle_message(event):
    # For Verify
    if (event.reply_token == '00000000000000000000000000000000' or
            event.reply_token == 'ffffffffffffffffffffffffffffffff'):
        app.logger.info('Verify Event Received')
        return
    # オウム返し
    line_bot_api.reply_message(
        event.reply_token,
        TextSendMessage(text=event.message.text))


if __name__ == "__main__":
    app.logger.setLevel(logging.DEBUG)
    app.run()
