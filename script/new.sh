#!/bin/bash -eu

function="${1}"

head=$(tr '[a-z]' '[A-Z]' <<< ${function:0:1})
tail=${function:1}
entry="${head}${tail}"

mkdir ./functions/${function}
touch ./functions/${function}/${function}.go

cat << EOF > ./functions/${function}/${function}.go
package ${function}

import (
	"fmt"
	"net/http"

	"github.com/GoogleCloudPlatform/functions-framework-go/functions"
)

func init() {
	functions.HTTP("${entry}", ${entry})
}

// ${entry} is an HTTP Cloud Function.
func ${entry}(w http.ResponseWriter, r *http.Request) {
	name := r.URL.Query().Get("name")
	if name == "" {
		name = "World"
	}
	fmt.Fprintf(w, "Hello, %s From ${entry}!", name)
}
EOF

mkdir ./functions/local
touch ./functions/local/main.go

cat << EOF > ./functions/local/main.go
package main

import (
	"log"

	_ "github.com/otakakot/emutate-cloud-functions/functions/${function}"

	// Blank-import the function package so the init() runs
	"github.com/GoogleCloudPlatform/functions-framework-go/funcframework"
)

func main() {
	if err := funcframework.Start("8080"); err != nil {
		log.Panicf("funcframework.Start: %v\n", err)
	}
}
EOF

module=($(head -n 1 ./go.mod))

mod="${module[1]}/functions/${function}"

(cd functions/${function} && go mod init ${mod} && go mod tidy)

go work use functions/${function}

go mod tidy

go fmt ./...

mkdir ./.docker/${function}
touch ./.docker/${function}/Dockerfile

cat << EOF > ./.docker/${function}/Dockerfile
FROM golang:1.21.1-alpine

WORKDIR /app

RUN go install github.com/cosmtrek/air@latest

WORKDIR /app/local/${function}

CMD ["air"]
EOF

cat << EOF >> ./.docker/compose.yaml
  ${function}:
    container_name: ${function}
    build:
      context: .
      dockerfile: ${function}/Dockerfile
    environment:
      FUNCTION_TARGET: ${entry}
    volumes:
      - ../:/app
    restart: always
EOF

old=$(sed -n '10p' ./.docker/compose.yaml)
new="${old},${function}"

sed -e "10s/.*/${new}/" ./.docker/compose.yaml >> ./.docker/compose.yaml.tmp

rm -rf ./.docker/compose.yaml

mv ./.docker/compose.yaml.tmp ./.docker/compose.yaml
