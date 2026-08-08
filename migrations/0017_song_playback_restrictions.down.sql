ALTER TABLE songs
DROP CONSTRAINT songs_playback_restriction_check;

ALTER TABLE songs
DROP COLUMN playback_restriction;
