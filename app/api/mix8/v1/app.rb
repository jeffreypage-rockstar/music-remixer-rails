module Mix8
  module V1
    class App < Grape::API
      include Mix8::V1::Defaults

      resource :app, desc: 'App' do
        desc 'Track app installs'
        post 'install' do
          response = {"success" => true}
          return response
        end

        desc 'Return app configuration information'
        get 'startup' do
          response = {"token" => ""}
          response["token"] = current_user.remember_token if current_user
          return response
        end
      end
    end
  end
end