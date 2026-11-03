ALTER TABLE sessions
    DROP COLUMN moderator_id,
    DROP COLUMN moderator_version,
    DROP COLUMN moderator_expires_at,
    DROP COLUMN moderator_session_id;
