CREATE TABLE listener_usage (
    listener_count BIGINT NOT NULL CHECK (listener_count > 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT DATE_TRUNC('minute', NOW()),
    PRIMARY KEY (created_at)
);
