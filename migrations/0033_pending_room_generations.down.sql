-- Pending jobs must be drained before rolling back this schema.
ALTER TABLE room_generations
ALTER COLUMN room_id SET NOT NULL,
DROP CONSTRAINT room_generations_pending_owner,
DROP COLUMN room_type,
DROP COLUMN owner_id;
