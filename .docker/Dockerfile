FROM golang:1.21.1-alpine

WORKDIR /app

RUN go install github.com/cosmtrek/air@latest

WORKDIR /app/local

CMD ["air"]
