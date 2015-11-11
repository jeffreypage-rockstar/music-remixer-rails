json.array!(@songs) do |song|
  json.extract! song, :id, :name, :duration, :zipfile, :mixaudio, :mixaudio2, :mixaudio3 
  json.url song_url(song, format: :json)
end
