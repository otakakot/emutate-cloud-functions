include .env
export

.PHONY: up
up:
	@docker compose --project-name function --file ./.docker/compose.yaml up -d

.PHONY: down
down:
	@docker compose --project-name function down --rmi all --volumes

.PHONY: reload
reload:
	@touch ./functions/bar/local/main.go
	@touch ./functions/foo/local/main.go

.PHONY: e2e
e2e:
	@go test -v ./e2e/...

.PHONY: e2e2cloud
e2e2cloud:
	@export ENDPOINT="" && go test -v ./e2e/...
