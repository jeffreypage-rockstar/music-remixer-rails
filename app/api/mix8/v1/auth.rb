module Mix8
  module V1
    class Auth < Grape::API
      include Mix8::V1::Defaults

      resource :auth, desc: 'User Authentication' do

        desc 'Return token if valid sign in'
        params do
          requires :login, type: String, desc: 'Username or Email'
          requires :password, type: String, desc: 'Password'
        end
        post :sign_in do
          user = User.where('lower(username) = :login OR lower(email) = :login', login: params[:login].downcase).first
          if user && user.authenticated?(params[:password])
            present user, with: Mix8::V1::Entities::User, expose_token: true
          else
            error!('Unauthorized (Invalid credentials)', 401)
          end
        end

        desc 'Return token if successful sign in with facebook'
        params do
          requires :oauth_access_token, type: String, desc: 'facebook oauth access token'
        end
        post :sign_in_with_facebook do
          graph = Koala::Facebook::API.new(params[:oauth_access_token])
          profile = graph.get_object('me', fields: 'first_name,last_name,email')
          user = User.find_for_facebook_oauth(profile)
          user.reset_remember_token!
          present user, with: Mix8::V1::Entities::User, expose_token: true
        end

        desc 'Reset token', { headers: { 'Authorization' => { description: 'Access Token', required: true } } }
        post :sign_out do
          current_user.reset_remember_token! if current_user
          response = {success: true}
          response
        end

        desc 'Create and return user if successful sign up'
        params do
          requires :email, type: String, desc: 'Email'
          requires :username, type: String, desc: 'Username'
          requires :password, type: String, desc: 'Password'
        end
        post :sign_up do
          user = User.new(declared(params))
          if user.save
            present user, with: Mix8::V1::Entities::User, expose_token: true
          else
            error!(user.errors.messages, 400)
          end
        end

        desc 'Connect account', { headers: { 'Authorization' => { description: 'Access Token', required: true } } }
        params do
          requires :provider, type: String, desc: 'Provider'
          requires :uid, type: String, desc: 'Uid'
          requires :token, type: String, desc: 'Token'
        end
        post 'connect/:provider' do
          authenticate!
          authentication = Authentication.find_by(provider: params[:provider], uid: params[:uid])
          if authentication
            unless authentication.user == current_user
              error!('Identity already added for another user', 422)
            else
              authentication.update_attribute(:token, params[:token])
            end
          else
            current_user.authentications.create(declared(params))
          end
        end
      end
    end
  end
end
