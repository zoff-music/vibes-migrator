ALTER TABLE songs ADD COLUMN IF NOT EXISTS duplicate_guard INTEGER;

WITH ranked_songs_q AS (
	SELECT
		a.id,
		COALESCE(b.allow_duplicates, 0) AS allow_duplicates,
		ROW_NUMBER() OVER (
			PARTITION BY a.room_id, a.source_type, a.source_id
			ORDER BY a.added_at ASC, a.id ASC
		) AS duplicate_rank
	FROM songs a
	LEFT JOIN room_settings b ON b.room_id = a.room_id
)
UPDATE songs a
SET duplicate_guard = CASE
	WHEN b.allow_duplicates = 0
	AND b.duplicate_rank = 1 THEN 1
	ELSE 0
END
FROM ranked_songs_q b
WHERE b.id = a.id;

UPDATE songs
SET duplicate_guard = 1
WHERE duplicate_guard IS NULL;

ALTER TABLE songs ALTER COLUMN duplicate_guard SET DEFAULT 1;

ALTER TABLE songs ALTER COLUMN duplicate_guard SET NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS idx_songs_duplicate_guard
ON songs(room_id, source_type, source_id)
WHERE duplicate_guard = 1;
