ALTER TABLE songs
ADD COLUMN metadata_updated_at TIMESTAMPTZ,
ADD COLUMN metadata_refresh_after TIMESTAMPTZ;

UPDATE songs
SET metadata_updated_at = added_at,
    metadata_refresh_after = LEAST(
        added_at + INTERVAL '21 days',
        NOW()
    );

ALTER TABLE songs
ALTER COLUMN metadata_updated_at SET DEFAULT NOW(),
ALTER COLUMN metadata_updated_at SET NOT NULL,
ALTER COLUMN metadata_refresh_after SET DEFAULT (
    NOW() + INTERVAL '21 days'
),
ALTER COLUMN metadata_refresh_after SET NOT NULL;

CREATE INDEX idx_songs_metadata_refresh
ON songs (source_type, metadata_refresh_after);
