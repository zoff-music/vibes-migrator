CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE sessions (
	id TEXT PRIMARY KEY,
	name TEXT NOT NULL,
	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO sessions (id, name)
SELECT DISTINCT
	a.added_by,
	b.name
FROM songs a
CROSS JOIN LATERAL (
	SELECT
		SPLIT_PART(c.name, '-', 1) || '-' || SPLIT_PART(c.name, '-', 2) AS name
	FROM room_name_pool c
	WHERE c.generated
	ORDER BY DIGEST(c.name || a.added_by, 'sha256')
	LIMIT 1
) b
WHERE a.added_by != '';
