# main properties of a song
json.extract! @song, :id, :name, :duration, :mixaudio, :mixaudio2, :mixaudio3, :created_at, :updated_at, :parts

# who's song is it
json.artist do
	json.id @song.user.id
	json.name @song.user.name
	json.username @song.user.username
end

# TODO: expose song stats

# Intro, Chorus, etc
json.sections do
	json.array! @song.parts do |part|
		json.extract! part, :id, :name, :duration, :column
	end
end

# the 8x8 grid of audio clips
json.clips do
	json.array! @song.clips do |clip|
		json.extract! clip, :id, :row, :column, :part_id, :state, :state2, :state3, :file, :user_content
	end
end

# vocals, drums, etc
json.parts do
	json.array! @song.clip_types do |clip_type|
		json.extract! clip_type, :id, :name, :row
	end
end