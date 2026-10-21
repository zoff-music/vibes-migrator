DROP TABLE room_reviews;
DROP INDEX rooms_flagged_dates;
DROP INDEX rooms_unchecked_names;
ALTER TABLE rooms
    DROP CONSTRAINT rooms_flagged_date,
    DROP COLUMN checked_at,
    DROP COLUMN flagged_at,
    DROP COLUMN flagged;
