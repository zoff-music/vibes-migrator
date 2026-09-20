# Vibes Migrator

PostgreSQL schema migrations for [Zoff](https://zoff.me), the shared music-room
application. This repository owns schema evolution and generated database
documentation, not the HTTP API or playback workers.

## Repository Layout

| Path | Responsibility |
| --- | --- |
| `cmd/migrator/main.go` | Command-line migration runner |
| `migrations/` | Ordered `NNNN_name.up.sql` / `NNNN_name.down.sql` pairs |
| `docs/db/` | Generated table documentation and relationships |
| `docker-compose.yml` | Disposable local PostgreSQL, migrator, and documentation tooling |
| `Dockerfile` | Migrator binary and bundled SQL files |
| `Makefile` | Build, integration checks, documentation generation, and image build |

The schema covers rooms and settings, songs and votes, playback and presence,
sessions and administrator authentication, OAuth, remote pairing, generated
playlists, staged playlist imports, reserved room names, and usage counters.
Chat usage counters are persistent; replayable chat/event delivery is handled
by the backend's Redis streams, not an unbounded chat transcript in PostgreSQL.

## Usage

Use the Go version declared in [go.mod](go.mod) or the container build. Run from
the repository root so the runner can find `./migrations`.

```bash
export DATABASE_URL='postgres://user:password@localhost:5432/vibes?sslmode=disable'
go run ./cmd/migrator/main.go up
```

`DATABASE_URL` or `-db` is required. `up` is the default command; `-steps N`
limits the number of migration versions applied. Zero means all applicable
versions.

```bash
# Apply one pending migration to a local database
go run ./cmd/migrator/main.go up -steps 1

# Revert one version only on a disposable database or with a reviewed rollback plan
go run ./cmd/migrator/main.go down -steps 1
```

**Down migrations can delete data.** Without `-steps`, `down` reverts all
applied versions. Back up production data and review the SQL before rollback.

The runner records versions in the `migrations` table. It marks a migration
dirty before executing SQL and clears that state on success. A dirty version
stops subsequent runs; inspect and repair the failed migration rather than
blindly clearing its status. Run one migrator per database at a time.

## Development and Checks

```bash
make build
make integrationtest
make docs
make docker
```

Integration checks apply migrations up and down against disposable local
PostgreSQL. Both `make integrationtest` and `make docs` use Docker Compose and
remove that Compose database volume as part of setup/cleanup. Do not point those
workflows at a database you need to retain.

`make docs` regenerates [docs/db](docs/db/README.md) with tbls. Update generated
documentation when changing the schema. Add a new numbered migration pair rather
than editing already-applied history.

## Relationship to the Applications

1. Apply a compatible schema change here.
2. Deploy [vibes-backend](https://github.com/zoff-music/vibes-backend), which owns
   prepared SQL, permission checks, SSE replay, and scheduled app-event processing.
3. Deploy [vibes-frontend](https://github.com/zoff-music/vibes-frontend) when the
   API or user interface changes.

Keep rolling upgrades compatible with both old and new application versions.
The backend does not apply migrations on startup. Documentation-only changes
do not add schema versions.

See the backend [architecture](https://github.com/zoff-music/vibes-backend/blob/main/docs/ARCHITECTURE.md)
for application boundaries and data flows.
