CREATE TABLE chat_usage (
    room_id TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    message_count BIGINT NOT NULL DEFAULT 0 CHECK (message_count >= 0),
    PRIMARY KEY (room_id, created_at)
);

CREATE INDEX idx_chat_usage_created_at ON chat_usage (created_at)
INCLUDE (message_count);
