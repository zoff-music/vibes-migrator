-- Covers room lookup by name in GetRoomByName and enforces the product rule
-- that room names are unique without changing existing room data.
CREATE UNIQUE INDEX IF NOT EXISTS idx_rooms_name_unique
ON rooms(name);

-- Covers OAuth provider listing for a user while filtering out expired refresh
-- windows in GetAuthProviders.
CREATE INDEX IF NOT EXISTS idx_access_tokens_user_refresh_expires_at
ON access_tokens(user_id, refresh_expires_at);

-- Covers expired refresh-token cleanup in DeleteExpiredAccessTokens.
CREATE INDEX IF NOT EXISTS idx_access_tokens_refresh_expires_at
ON access_tokens(refresh_expires_at);

-- Covers worker token claiming in ClaimAndGetExpiredTokenForRefresh: provider
-- filter, expired access token filter, live refresh-token filter, and oldest
-- last_checked ordering before FOR UPDATE SKIP LOCKED.
CREATE INDEX IF NOT EXISTS idx_access_tokens_refresh_claim
ON access_tokens(provider, expires_at, refresh_expires_at, last_checked);

-- Covers pending OAuth callback validation by state while ignoring expired
-- state rows in ValidatePendingOAuthState.
CREATE INDEX IF NOT EXISTS idx_pending_oauth_state_state_expires_at
ON pending_oauth_state(state, expires_at);

-- Covers active participant listing and listener counting by room with the
-- recent last_seen_at cutoff.
CREATE INDEX IF NOT EXISTS idx_room_users_room_last_seen_at
ON room_users(room_id, last_seen_at);

-- Covers admin room summaries that count active non-cast listeners by room.
CREATE INDEX IF NOT EXISTS idx_room_users_active_listener_room_last_seen_at
ON room_users(room_id, last_seen_at)
WHERE is_active_listener = 1
AND is_cast_receiver = 0;

-- Covers duplicate detection in AddSong regardless of whether room settings
-- currently allow duplicates, while the partial unique duplicate_guard index
-- still enforces the disallow-duplicates case.
CREATE INDEX IF NOT EXISTS idx_songs_room_source
ON songs(room_id, source_type, source_id);

-- Covers queue reads and next-song selection by room, ordered by added_at.
CREATE INDEX IF NOT EXISTS idx_songs_room_added_at
ON songs(room_id, added_at);
