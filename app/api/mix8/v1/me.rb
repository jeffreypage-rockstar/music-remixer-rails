module Mix8
  module V1
    class Me < Grape::API
      include Mix8::V1::Defaults

      resource :me, desc: 'Me' do

        desc 'Get user\'s profile', { headers: { 'Authorization' => { description: 'Access Token', required: true } } }
        get :profile do
          present current_user, with: Mix8::V1::Entities::User
        end

        desc 'Get user\'s remixes', { headers: { 'Authorization' => { description: 'Access Token', required: true } } }
        get :remixes do
          present current_user.released_remixes, with: Mix8::V1::Entities::Remix
        end
      
      end
    end
  end
end
