.PHONY: build install update help test integrationtest docs docker security gosec govulncheck

PROJECT_NAME=$(shell basename $(CURDIR))
DOCS_DATABASE_URL ?=
GOSEC_VERSION ?= 71577268350e1e0f2f1491de1ef53f1227b43c1f
GOVULNCHECK_VERSION ?= latest

## build: builds the migrator binary
build: security
	go mod download
	CGO_ENABLED=0 go build -ldflags '-w -s' -o vibes-migrator cmd/migrator/main.go

## install: fetches Go modules
install:
	go mod tidy; \
	go mod download

## update: updates Go dependencies
update:
	go get -u ./...
	go mod tidy
	go mod download

## test: runs race-enabled Go package checks
test:
	go test -race ./...

## security: runs both security checks before building
security: gosec govulncheck

## gosec: runs gosec at the configured upstream commit
gosec:
	go run github.com/securego/gosec/v2/cmd/gosec@$(GOSEC_VERSION) ./...

## govulncheck: runs the latest govulncheck release
govulncheck:
	go run golang.org/x/vuln/cmd/govulncheck@$(GOVULNCHECK_VERSION) ./...

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
ifneq ($(strip $(DOCS_DATABASE_URL)),)
	tbls doc --force "$(DOCS_DATABASE_URL)" docs/db
else
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
endif

## docker: builds the production migrator image
docker:
	docker build -t $(PROJECT_NAME) .

## help: prints help message
help:
	@echo "Usage:"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'
