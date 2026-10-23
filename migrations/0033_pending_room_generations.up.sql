ALTER TABLE room_generations
ALTER COLUMN room_id DROP NOT NULL,
ADD COLUMN owner_id TEXT,
ADD COLUMN room_type room_type NOT NULL DEFAULT 'MUSIC',
ADD CONSTRAINT room_generations_pending_owner CHECK (
	room_id IS NOT NULL OR (owner_id IS NOT NULL AND owner_id != '')
);
