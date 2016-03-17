module Mix8
  module V1
    class Remixes < Grape::API
      include Mix8::V1::Defaults
      include Grape::Kaminari

      resource :remixes, desc: 'Songs' do
        desc 'Get remix by id', {headers: {'Authorization' => {description: 'Access Token', required: true}}}
        get ':id' do
          remix = Remix.find(params[:id])
          present remix, with: Mix8::V1::Entities::Remix, type: :full
        end

        desc 'Update remix by id', {headers: {'Authorization' => {description: 'Access Token', required: true}}}
        params do
          requires :id, type: Integer, desc: 'Remix id'
          optional :name, type: String, desc: 'Name of remix'
          optional :automation, type: String, desc: 'Automation'
          optional :config, type: String, desc: 'Config'
          optional :audio, type: File, desc: 'Audio file'
        end
        put ':id' do
          remix = Remix.find(params[:id])
          present remix, with: Mix8::V1::Entities::Remix
        end
      end

      resource :songs, desc: 'Songs' do
        params do
          requires :song_id, type: Integer, desc: 'Song id'
        end
        route_param :song_id do
          resources :remixes, desc: 'Mixes' do
            desc 'Create new remix', {headers: {'Authorization' => {description: 'Access Token', required: true}}}
            params do
              requires :name, type: String, desc: 'Name of remix'
              requires :automation, type: String, desc: 'Automation'
              requires :config, type: String, desc: 'Config'
              requires :audio, type: File, desc: 'Audio file'
            end
            post do
              authenticate!
              remix = current_user.remixes.new(declared(params))
              if remix.save
                User.increment_counter(:remixes_count, remix.user_id)
                present remix, with: Mix8::V1::Entities::Remix
              else
                error!(remix.errors.messages, 400)
              end
            end
          end
        end
      end
    end
  end
end