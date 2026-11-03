ALTER TABLE sessions
    ADD COLUMN moderator_id TEXT,
    ADD COLUMN moderator_version BIGINT,
    ADD COLUMN moderator_expires_at TIMESTAMP,
    ADD COLUMN moderator_session_id TEXT;
