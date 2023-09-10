FROM golang:1.21.1-alpine

WORKDIR /app

RUN go install github.com/cosmtrek/air@latest

WORKDIR /app/functions/foo/local

CMD ["air"]
