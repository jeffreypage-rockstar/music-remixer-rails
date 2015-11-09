json.array!(@songs) do |song|
	json.extract! song, :id, :name, :duration, :mixaudio, :mixaudio2, :mixaudio3
end
