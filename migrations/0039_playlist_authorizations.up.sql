CREATE TABLE playlist_authorizations (
    code_hash TEXT PRIMARY KEY,
    source_hash TEXT NOT NULL,
    access_token TEXT NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL
);

CREATE INDEX playlist_authorizations_expiry_idx ON playlist_authorizations (expires_at);
