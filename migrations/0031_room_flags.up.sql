ALTER TABLE rooms
    ADD COLUMN flagged BOOLEAN NOT NULL DEFAULT FALSE,
    ADD COLUMN flagged_at TIMESTAMP,
    ADD COLUMN checked_at TIMESTAMP,
    ADD CONSTRAINT rooms_flagged_date CHECK (flagged = (flagged_at IS NOT NULL));

CREATE INDEX rooms_unchecked_names ON rooms (created_at, id)
    WHERE checked_at IS NULL;
CREATE INDEX rooms_flagged_dates ON rooms (flagged_at DESC) WHERE flagged;

CREATE TABLE room_reviews (
    id BOOLEAN PRIMARY KEY DEFAULT TRUE CHECK (id),
    started_at TIMESTAMP
);
INSERT INTO room_reviews (id) VALUES (TRUE);
