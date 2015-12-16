# main properties of a song
json.id @song.id
json.name @song.name
json.duration @song.duration.to_s
json.bpm @song.bpm
json.preview_url @song.preview_url
json.created_at @song.created_at

# who's song is it
json.artist do
	json.id @song.user.id
	json.name @song.user.name
	json.username @song.user.username
end

# TODO: expose song stats

# Vocals, Drums, etc
json.sections do
	json.array! @song.clip_types do |clip_type|
		json.extract! clip_type, :id, :name, :row
	end
end

# Intro, Chorus, etc
json.parts do
	json.array! @song.parts do |part|
		json.extract! part, :id, :name, :duration, :column
	end
end

# the 8x8 grid of audio clips
json.clips do
	json.array! @song.clips do |clip|
		json.extract! clip, :id, :row, :column, :state, :state2, :state3, :allow_ugc
		json.section_id clip.clip_type_id
		json.part_id clip.part_id
		json.url clip.file.to_s
	end
end

