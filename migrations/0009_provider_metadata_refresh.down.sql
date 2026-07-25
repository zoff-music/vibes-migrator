DROP INDEX IF EXISTS idx_songs_metadata_refresh;

ALTER TABLE songs
DROP COLUMN IF EXISTS metadata_refresh_after,
DROP COLUMN IF EXISTS metadata_updated_at;
