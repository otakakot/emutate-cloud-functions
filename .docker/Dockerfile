FROM golang:1.21.6-alpine

WORKDIR /app

RUN go install github.com/cosmtrek/air@latest

WORKDIR /app/local

CMD ["air"]
