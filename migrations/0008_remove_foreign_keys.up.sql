ALTER TABLE playback_state
DROP CONSTRAINT playback_state_room_id_fkey;

ALTER TABLE room_settings
DROP CONSTRAINT room_settings_room_id_fkey;

ALTER TABLE room_users
DROP CONSTRAINT room_users_room_id_fkey;

ALTER TABLE skip_votes
DROP CONSTRAINT skip_votes_room_id_fkey,
DROP CONSTRAINT skip_votes_song_id_fkey;

ALTER TABLE songs
DROP CONSTRAINT songs_room_id_fkey;

ALTER TABLE song_votes
DROP CONSTRAINT song_votes_room_id_fkey,
DROP CONSTRAINT song_votes_song_id_fkey;
