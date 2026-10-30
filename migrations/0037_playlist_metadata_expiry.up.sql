CREATE INDEX idx_playlist_items_youtube_metadata_expiry
ON playlist_items (metadata_updated_at, room_id)
WHERE source_type = 'youtube';
