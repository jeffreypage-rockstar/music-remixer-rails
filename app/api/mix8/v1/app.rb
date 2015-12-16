module Mix8
  module V1
    class App < Grape::API
      include Mix8::V1::Defaults

      resource :app, desc: 'App' do
        desc 'Track app installs', { headers: { 'Authorization' => { description: 'Access Token', required: false } } }
        get 'install' do
          "ok"
        end

        desc 'Return app configuration information', { headers: { 'Authorization' => { description: 'Access Token', required: false } } }
        get 'config' do
          "ok"
        end
      end
    end
  end
end