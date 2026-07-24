DROP INDEX room_generations_claim_idx;
DROP INDEX room_generations_single_active_idx;

ALTER TABLE room_generations
DROP CONSTRAINT room_generations_pkey,
ADD COLUMN id BIGINT GENERATED ALWAYS AS IDENTITY,
ADD COLUMN completed_at TIMESTAMP,
ADD COLUMN failed_at TIMESTAMP,
ADD CONSTRAINT room_generations_single_outcome CHECK (
	completed_at IS NULL OR failed_at IS NULL
),
ADD CONSTRAINT room_generations_failure_attempt CHECK (
	failed_at IS NULL OR attempt >= 5
),
ADD CONSTRAINT room_generations_pkey PRIMARY KEY (id);

CREATE INDEX room_generations_claim_idx
ON room_generations (updated_at, created_at)
WHERE completed_at IS NULL
AND failed_at IS NULL;

CREATE UNIQUE INDEX room_generations_single_active_idx
ON room_generations ((TRUE))
WHERE completed_at IS NULL
AND failed_at IS NULL
AND attempt < 5;

CREATE INDEX room_generations_room_created_idx
ON room_generations (room_id, created_at);

CREATE INDEX room_generations_completed_at_idx
ON room_generations (completed_at)
WHERE completed_at IS NOT NULL;

CREATE INDEX room_generations_failed_at_idx
ON room_generations (failed_at)
WHERE failed_at IS NOT NULL;
