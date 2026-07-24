CREATE TABLE room_generations (
	room_id TEXT PRIMARY KEY,
	prompt TEXT NOT NULL CHECK (
		LENGTH(BTRIM(prompt)) BETWEEN 1 AND 300
	),
	attempt INTEGER NOT NULL DEFAULT 0 CHECK (
		attempt BETWEEN 0 AND 5
	),
	created_at TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC'),
	updated_at TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC')
);

CREATE INDEX room_generations_claim_idx
ON room_generations (updated_at, created_at);

CREATE UNIQUE INDEX room_generations_single_active_idx
ON room_generations ((TRUE))
WHERE attempt < 5;
