.PHONY: build install update help integrationtest docs docker

PROJECT_NAME=$(shell basename $(CURDIR))

## build: builds the migrator binary
build:
	go mod download; \
	CGO_ENABLED=0 go build -ldflags '-w -s' -o vibes-migrator cmd/migrator/main.go

## install: fetches Go modules
install:
	go mod tidy; \
	go mod download

## update: updates Go dependencies
update:
	go get -u ./...; \
	go mod download; \
	go mod tidy

## integrationtest: runs migrator up and down against local Postgres
integrationtest:
	@set -e; \
	trap 'echo "Stopping postgres..." && docker compose down -v' EXIT INT TERM; \
	docker compose down -v 2>/dev/null || true; \
	echo "Starting postgres..."; \
	docker compose up -d shared-local; \
	echo "Waiting for postgres..."; \
	sleep 5; \
	echo "Running migrations up..."; \
	docker compose run --rm --build migrator up; \
	echo "Running migrations down..."; \
	docker compose run --rm migrator down

## docs: generates database table documentation using tbls
docs:
	@set -e; \
	trap 'echo "Stopping postgres..." && docker compose down -v' EXIT INT TERM; \
	docker compose down -v 2>/dev/null || true; \
	echo "Starting postgres..."; \
	docker compose up -d shared-local; \
	echo "Waiting for postgres..."; \
	sleep 5; \
	echo "Running migrations..."; \
	docker compose run --rm --build migrator up; \
	echo "Generating database documentation..."; \
	rm -rf docs/db; \
	mkdir -p docs/db; \
	docker compose run --rm tbls

## docker: builds the production migrator image
docker:
	docker build -t $(PROJECT_NAME) .

## help: prints help message
help:
	@echo "Usage:"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'
