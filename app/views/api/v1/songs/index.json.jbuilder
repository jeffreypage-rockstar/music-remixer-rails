json.array!(@songs) do |song|
	json.id song.id
	json.name song.name
	json.duration song.duration
	json.preview_url song.preview_url
	json.image song.image
	json.artist do
		json.id song.user.id
		json.name song.user.name
	end
end
