FROM golang:1.15.2-buster as builder
COPY example/go /app
WORKDIR /app
RUN GO111MODULE=on go mod download && GOOS=linux GOARCH=amd64 go build -o /go/bin/linebot

# hadolint ignore=DL3007
FROM gcr.io/distroless/base-debian10:latest
COPY --from=builder /go/bin/linebot /bin/linebot
ENTRYPOINT [ "/bin/linebot" ]
