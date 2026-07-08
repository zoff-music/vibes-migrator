DROP INDEX IF EXISTS idx_songs_duplicate_guard;

ALTER TABLE songs DROP COLUMN IF EXISTS duplicate_guard;
