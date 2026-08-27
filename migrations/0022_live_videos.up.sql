WITH live_songs_q AS (
	SELECT id, room_id
	FROM songs
	WHERE source_type = 'youtube'
	AND duration <= 0
),
next_songs_q AS (
	SELECT
		a.id AS live_song_id,
		b.id AS next_song_id
	FROM live_songs_q a
	LEFT JOIN LATERAL (
		SELECT c.id
		FROM songs c
		LEFT JOIN song_votes d
		ON d.room_id = c.room_id
		AND d.song_id = c.id
		WHERE c.room_id = a.room_id
		AND c.id <> a.id
		AND NOT (c.source_type = 'youtube' AND c.duration <= 0)
		GROUP BY c.id
		ORDER BY COUNT(d.user_id) DESC, MAX(d.created_at) ASC, c.added_at ASC
		LIMIT 1
	) b ON TRUE
),
updated_playback_q AS (
	UPDATE playback_state a
	SET current_song_id = COALESCE(c.next_song_id, ''),
		is_playing = c.next_song_id IS NOT NULL,
		position_ms = 0,
		updated_at = CURRENT_TIMESTAMP AT TIME ZONE 'UTC'
	FROM live_songs_q b
	JOIN next_songs_q c
	ON c.live_song_id = b.id
	WHERE a.current_song_id = b.id
	RETURNING a.room_id
),
deleted_skip_votes_q AS (
	DELETE FROM skip_votes a
	USING live_songs_q b
	WHERE a.song_id = b.id
	RETURNING a.song_id
),
deleted_song_votes_q AS (
	DELETE FROM song_votes a
	USING live_songs_q b
	WHERE a.song_id = b.id
	RETURNING a.song_id
)
DELETE FROM songs a
USING live_songs_q b
WHERE a.id = b.id;

ALTER TABLE songs
ADD CONSTRAINT songs_youtube_duration_check
CHECK (source_type <> 'youtube' OR duration > 0);
