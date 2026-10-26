CREATE TABLE search_claims (
    query_hash TEXT PRIMARY KEY,
    token UUID NOT NULL,
    expires_at TIMESTAMP NOT NULL
);

CREATE INDEX search_claims_expires_at_idx ON search_claims (expires_at);

CREATE TABLE search_budgets (
    id BOOLEAN PRIMARY KEY DEFAULT TRUE CHECK (id),
    quota_day DATE NOT NULL DEFAULT CURRENT_DATE,
    search_count INTEGER NOT NULL DEFAULT 0,
    generation_count INTEGER NOT NULL DEFAULT 0,
    started_at TIMESTAMP
);

INSERT INTO search_budgets (id) VALUES (TRUE);

CREATE TABLE search_attempts (
    id UUID PRIMARY KEY,
    query_hash TEXT NOT NULL,
    room_id TEXT NOT NULL,
    user_id TEXT NOT NULL,
    purpose TEXT NOT NULL,
    outcome TEXT NOT NULL DEFAULT 'reserved',
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX search_attempts_created_at_idx ON search_attempts (created_at);
CREATE INDEX search_attempts_user_created_at_idx ON search_attempts (user_id, created_at);
CREATE INDEX search_attempts_room_created_at_idx ON search_attempts (room_id, created_at);
