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
