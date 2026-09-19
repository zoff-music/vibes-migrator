CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Supports case-insensitive substring searches without scanning every name.
CREATE INDEX idx_rooms_name_search
ON rooms USING gin (name gin_trgm_ops);
