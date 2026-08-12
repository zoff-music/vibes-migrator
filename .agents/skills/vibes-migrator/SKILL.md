---
name: vibes-migrator
description: Build, review, or debug the Vibes Go database migrator, including reversible PostgreSQL migrations, generated database documentation, deployment behavior, and migration tests.
---

# Vibes Migrator

Use these rules for Go migrator work in this repository.

## Workflow

1. This repository owns the Vibes database migration app.
2. `cmd/migrator` is the migration CLI entrypoint.
3. `migrations/` contains incrementally numbered SQL up/down migrations. Never edit an already-merged migration; add the next numbered migration instead.
4. `docs/db` contains generated tbls database docs.
5. Run `make docs`, `make test`, and `make integrationtest` before finishing migrator changes when they are relevant.
6. Inspect the matching database client in `~/dev/zoff-music/vibes-backend` before designing a schema change; migrations and prepared statements must agree on columns, indexes, and nullability.

## Migration Rules

- Migrations must be reversible with matching `.up.sql` and `.down.sql` files.
- Use normal table constraints and indexes for data integrity. Do not add guard tables unless explicitly requested.
- Keep SQL aliases readable and consistent with the backend query style.
- CTE names should end in `_q`.
- Avoid destructive data changes unless explicitly requested and called out.
- Preserve remote-control playback state, public-room visibility, generation state, and provider restrictions when changing room-related tables.

## Deployment

- The migrator deploys as the `vibes-migrator` Kubernetes job, not as part of `vibes-backend`.
- The job should complete and be removed/replaced by deploy automation; it must not run as a persistent service.
- Deployment changes that touch cluster behavior may also require coordinated updates in `~/dev/infra`.
- Backend code ships separately from this migration job. Document and order cross-repository changes so a deploy never queries a schema that has not been migrated yet.
