DROP INDEX room_generations_failed_at_idx;
DROP INDEX room_generations_completed_at_idx;
DROP INDEX room_generations_room_created_idx;
DROP INDEX room_generations_single_active_idx;
DROP INDEX room_generations_claim_idx;

DELETE FROM room_generations
WHERE completed_at IS NOT NULL
OR failed_at IS NOT NULL;

ALTER TABLE room_generations
DROP CONSTRAINT room_generations_pkey,
DROP CONSTRAINT room_generations_failure_attempt,
DROP CONSTRAINT room_generations_single_outcome,
DROP COLUMN failed_at,
DROP COLUMN completed_at,
DROP COLUMN id,
ADD CONSTRAINT room_generations_pkey PRIMARY KEY (room_id);

CREATE INDEX room_generations_claim_idx
ON room_generations (updated_at, created_at);

CREATE UNIQUE INDEX room_generations_single_active_idx
ON room_generations ((TRUE))
WHERE attempt < 5;
