ALTER TABLE room_settings
ADD COLUMN is_public BOOLEAN NOT NULL DEFAULT FALSE;

CREATE INDEX idx_room_settings_public
ON room_settings(room_id)
WHERE is_public;
