json.array!(@songs) do |song|
  json.extract! song, :id, :name, :duration, :zipfile
  json.url song_url(song, format: :json)
end
