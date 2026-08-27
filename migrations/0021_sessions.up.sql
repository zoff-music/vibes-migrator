CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE sessions (
	id TEXT PRIMARY KEY,
	name TEXT NOT NULL,
	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

WITH contributors_q AS (
	SELECT DISTINCT added_by
	FROM songs
	WHERE added_by != ''
),
pool_size_q AS (
	SELECT COUNT(*)::BIGINT AS name_count
	FROM room_name_pool
	WHERE generated
),
selected_names_q AS (
	SELECT
		a.added_by,
		1 + MOD(
			(
				'x'
				|| LEFT(ENCODE(DIGEST(a.added_by, 'sha256'), 'hex'), 15)
			)::BIT(60)::BIGINT,
			b.name_count
		) AS room_name_id
	FROM contributors_q a
	CROSS JOIN pool_size_q b
	WHERE b.name_count > 0
)
INSERT INTO sessions (id, name)
SELECT
	a.added_by,
	SPLIT_PART(b.name, '-', 1) || '-' || SPLIT_PART(b.name, '-', 2)
FROM selected_names_q a
JOIN room_name_pool b ON b.id = a.room_name_id
WHERE b.generated;
