ALTER TABLE playback_state
ADD CONSTRAINT playback_state_room_id_fkey
FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE;

ALTER TABLE room_settings
ADD CONSTRAINT room_settings_room_id_fkey
FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE;

ALTER TABLE room_users
ADD CONSTRAINT room_users_room_id_fkey
FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE;

ALTER TABLE skip_votes
ADD CONSTRAINT skip_votes_room_id_fkey
FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE,
ADD CONSTRAINT skip_votes_song_id_fkey
FOREIGN KEY (song_id) REFERENCES songs(id) ON DELETE CASCADE;

ALTER TABLE songs
ADD CONSTRAINT songs_room_id_fkey
FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE;

ALTER TABLE song_votes
ADD CONSTRAINT song_votes_room_id_fkey
FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE,
ADD CONSTRAINT song_votes_song_id_fkey
FOREIGN KEY (song_id) REFERENCES songs(id) ON DELETE CASCADE;
