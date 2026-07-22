CREATE TABLE rate_limits (
    route_name TEXT NOT NULL,
    scope TEXT NOT NULL CHECK (scope IN ('device', 'ip')),
    identity_hash VARCHAR(64) NOT NULL CHECK (LENGTH(identity_hash) = 64),
    request_count INTEGER NOT NULL CHECK (request_count >= 1),
    request_limit INTEGER NOT NULL CHECK (request_limit >= 1),
    window_started_at TIMESTAMP NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    PRIMARY KEY (route_name, scope, identity_hash),
    CHECK (expires_at > window_started_at)
);

CREATE INDEX idx_rate_limits_expires_at
ON rate_limits(expires_at);
