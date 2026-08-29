CREATE TABLE playlist_imports (
	id TEXT PRIMARY KEY,
	room_id TEXT NOT NULL,
	added_by TEXT NOT NULL,
	next_position INTEGER NOT NULL DEFAULT 0,
	attempts INTEGER NOT NULL DEFAULT 0,
	updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	CONSTRAINT playlist_imports_next_position_non_negative CHECK (next_position >= 0),
	CONSTRAINT playlist_imports_attempts_non_negative CHECK (attempts >= 0)
);

CREATE TABLE playlist_import_items (
	id TEXT PRIMARY KEY,
	import_id TEXT NOT NULL,
	position INTEGER NOT NULL,
	source_type TEXT NOT NULL,
	source_id TEXT NOT NULL,
	provider_url TEXT NOT NULL DEFAULT '',
	playback_restriction TEXT NOT NULL DEFAULT '',
	title TEXT NOT NULL,
	artist TEXT NOT NULL DEFAULT '',
	thumbnail_url TEXT NOT NULL DEFAULT '',
	duration INTEGER NOT NULL,
	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	CONSTRAINT playlist_import_items_position_non_negative CHECK (position >= 0),
	CONSTRAINT playlist_import_items_duration_non_negative CHECK (duration >= 0),
	CONSTRAINT playlist_import_items_import_position_unique UNIQUE (import_id, position)
);

CREATE INDEX playlist_imports_processing_idx
	ON playlist_imports (updated_at, created_at);

CREATE INDEX playlist_import_items_import_position_idx
	ON playlist_import_items (import_id, position);
