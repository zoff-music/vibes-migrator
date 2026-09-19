# Vibes Migrator

Postgres schema migrator for Vibes.

## Usage

```bash
export DATABASE_URL=postgres://user:password@localhost:5432/vibes?sslmode=disable
go run ./cmd/migrator/main.go up
```

## Local Checks

```bash
make integrationtest
make docs
```

`make docs` generates tbls database documentation in `docs/db/`.

## Public room search

Migration 0025 enables `pg_trgm` and adds a GIN index on room names for
case-insensitive substring searches. Ship it before clients start using the
v2 public-room browser in `zoff-music/vibes-backend`. The backend query remains
compatible with the earlier schema; the index improves search performance.

Rollback removes the index and leaves the extension installed so other
trigram indexes remain usable.
