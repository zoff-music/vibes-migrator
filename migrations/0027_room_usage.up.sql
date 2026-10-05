CREATE TABLE room_search_usage (
    room_id TEXT NOT NULL,
    provider TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    search_count BIGINT NOT NULL DEFAULT 0 CHECK (search_count >= 0),
    cached_count BIGINT NOT NULL DEFAULT 0 CHECK (cached_count >= 0),
    PRIMARY KEY (room_id, provider, created_at)
);

CREATE INDEX idx_room_search_usage_created_at ON room_search_usage (created_at);

CREATE TABLE room_listener_usage (
    room_id TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    listener_count BIGINT NOT NULL CHECK (listener_count >= 0),
    PRIMARY KEY (room_id, created_at)
);

CREATE INDEX idx_room_listener_usage_created_at ON room_listener_usage (created_at);
