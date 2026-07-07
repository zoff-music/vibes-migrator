ARG GO_BASE_IMAGE=golang:1.26.4-bookworm

FROM ${GO_BASE_IMAGE} AS builder

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 go build -ldflags '-w -s' -o /out/vibes-migrator cmd/migrator/main.go

FROM debian:bookworm-slim

RUN apt-get update \
	&& apt-get install -y --no-install-recommends ca-certificates \
	&& rm -rf /var/lib/apt/lists/* \
	&& groupadd --system appuser \
	&& useradd --system --gid appuser --home-dir /app appuser

WORKDIR /app

COPY --from=builder /out/vibes-migrator /app/vibes-migrator
COPY migrations /app/migrations

RUN chown -R appuser:appuser /app

USER appuser:appuser

ENTRYPOINT ["/app/vibes-migrator"]
