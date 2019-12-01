package main

import (
	"log"
	"net/http"
	"os"

	"github.com/line/line-bot-sdk-go/linebot"
)

func main() {
	// create app
	botApp, err := linebot.New(
		os.Getenv("LINE_BOT_GO_CHANNEL_SECRET"),
		os.Getenv("LINE_BOT_GO_CHANNEL_TOKEN"),
	)
	if err != nil {
		log.Fatal(err)
	}

	// define handle function
	handleFunction := func(resWriter http.ResponseWriter, request *http.Request) {
		events, err := botApp.ParseRequest(request)
		if err != nil {
			if err == linebot.ErrInvalidSignature {
				resWriter.WriteHeader(400)
			} else {
				resWriter.WriteHeader(500)
			}
			return
		}
		// handling event
		for _, event := range events {
			log.Printf("Recieve Event: %v", event)
			// Message受信
			if event.Type == linebot.EventTypeMessage {
				switch message := event.Message.(type) {
				case *linebot.TextMessage:
					// TextMessageをおうむ返し
					if _, err = botApp.ReplyMessage(event.ReplyToken, linebot.NewTextMessage(message.Text)).Do(); err != nil {
						// 標準のログライブラリにロギングレベルの概念はない
						log.Print(err)
					}
				}
			}
		}
	}
	// set handler (Routing = /callback)
	http.HandleFunc("/callback", handleFunction)
	// LISTEN PORT
	log.Print("Listen Port:9070")
	if err := http.ListenAndServe(":9070", nil); err != nil {
		log.Fatal(err)
	}
}
