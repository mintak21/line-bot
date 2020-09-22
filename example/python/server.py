import logging
import os

from flask import Flask, abort, request
from linebot import LineBotApi, WebhookHandler
from linebot.exceptions import InvalidSignatureError
from linebot.models import MessageEvent, TextMessage, TextSendMessage

app = Flask(__name__)
handler = WebhookHandler(os.getenv('CHANNEL_SECRET'))
line_bot_api = LineBotApi(os.getenv('CHANNEL_ACCESS_TOKEN'))


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
