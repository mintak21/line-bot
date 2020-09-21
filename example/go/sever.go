package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/line/line-bot-sdk-go/linebot"
)

func main() {
	// create Handler
	handler, err := newHandler()
	if err != nil {
		log.Fatal(err)
	}
	// set handler (Routing = /callback)
	http.HandleFunc("/callback", handler.HandleEvent)
	// LISTEN PORT
	if err := http.ListenAndServe(fmt.Sprintf(":%s", os.Getenv("PORT")), nil); err != nil {
		log.Fatal(err)
	}
}

type EventHandler interface {
	HandleEvent(resWriter http.ResponseWriter, request *http.Request)
}

type eventHandler struct {
	client *linebot.Client
}

func newHandler() (EventHandler, error) {
	// create app
	client, err := linebot.New(
		os.Getenv("CHANNEL_SECRET"),
		os.Getenv("CHANNEL_ACCESS_TOKEN"),
	)
	if err != nil {
		return nil, err
	}
	return &eventHandler{
		client: client,
	}, nil
}

func (h *eventHandler) HandleEvent(resWriter http.ResponseWriter, request *http.Request) {
	events, err := h.client.ParseRequest(request)
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
		log.Printf("Receive Event: %v", event)
		// Message受信
		if event.Type == linebot.EventTypeMessage {
			switch message := event.Message.(type) {
			case *linebot.TextMessage:
				// TextMessageをおうむ返し
				if _, err = h.client.ReplyMessage(event.ReplyToken, linebot.NewTextMessage(message.Text)).Do(); err != nil {
					// 標準のログライブラリにロギングレベルの概念はない
					log.Print(err)
				}
			}
		}
	}
}
