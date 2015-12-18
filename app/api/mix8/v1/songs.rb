module Mix8
  module V1
    class Songs < Grape::API
      include Mix8::V1::Defaults
      include Grape::Kaminari

      resource :songs, desc: 'Songs' do
        desc 'Get list of songs', { headers: { 'Authorization' => { description: 'Access Token', required: true } } }
        paginate per_page: 20, max_per_page: 100, offset: 0
        get do
          authenticate!
          songs = paginate(Song.released)
          present songs, with: Mix8::V1::Entities::Song
        end

        desc 'Get a song', { headers: { 'Authorization' => { description: 'Access Token', required: true } } }
        params do
          requires :id, type: Integer, desc: 'Song id'
        end
        get ':id' do
          authenticate!
          song = Song.includes(:clip_types, :parts, :clips).released.find_by(id: params[:id])
          present song, with: Mix8::V1::Entities::Song, type: :full
        end

        desc 'Get a song waveform', { headers: { 'Authorization' => { description: 'Access Token', required: true } } }
        params do
          requires :id, type: Integer, desc: 'Song id'
        end
        get ':id' do
          authenticate!
          song = Song.released.find_by(id: params[:id])
          present song, with: Mix8::V1::Entities::SongWaveform
        end
      end
    end
  end
end