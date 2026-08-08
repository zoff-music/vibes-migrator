ALTER TABLE songs
ADD COLUMN playback_restriction TEXT NOT NULL DEFAULT '';

ALTER TABLE songs
ADD CONSTRAINT songs_playback_restriction_check
CHECK (playback_restriction IN ('', 'age', 'region', 'embedding'));
