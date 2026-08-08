CREATE TABLE remote_controls (
    id TEXT PRIMARY KEY,
    owner_user_id TEXT NOT NULL UNIQUE,
    pairing_token_hash TEXT NOT NULL,
    pairing_code_hash TEXT NOT NULL,
    controller_token_hash TEXT NOT NULL DEFAULT '',
    current_room_id TEXT NOT NULL DEFAULT '',
    pairing_expires_at TIMESTAMPTZ NOT NULL,
    last_seen_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX remote_controls_pairing_token_hash_idx
ON remote_controls (pairing_token_hash)
WHERE pairing_token_hash != '';

CREATE UNIQUE INDEX remote_controls_controller_token_hash_idx
ON remote_controls (controller_token_hash)
WHERE controller_token_hash != '';
