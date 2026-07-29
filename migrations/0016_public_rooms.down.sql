DROP INDEX IF EXISTS idx_room_settings_public;

ALTER TABLE room_settings
DROP COLUMN IF EXISTS is_public;
