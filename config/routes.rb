require 'sidekiq/web'

Rails.application.routes.draw do
	# API subdomain
	constraints :subdomain => 'api' do
		mount Mix8::Base => '/'
	end

  # Artist subdomain
	constraints :subdomain => 'artist' do
		namespace :artist, path: '/' do
			get '/' => 'artist#index'
			get 'profile' => 'artist#profile', as: 'profile'
			get 'profile/edit' => 'artist#edit_profile', as: 'edit_profile'
			patch 'profile/update' => 'artist#update_profile', as: 'update_profile'
			patch 'profile/update_account' => 'artist#update_account', as: 'update_account'
			post 'profile/follow' => 'artist#follow', as: 'follow'
			delete 'profile/unfollow' => 'artist#unfollow', as: 'unfollow'
			get 'dashboard' => 'artist#dashboard', as: 'dashboard'
			get 'music' => 'songs#index', as: 'music'
			get 'connect' => 'artist#connect', as: 'connect'
			get 'activities' => 'artist#activities', as: 'activities'
			delete 'identity/:provider/disconnect' => 'artist#disconnect_identity', as: 'disconnect_identity'

			# had to move parts out from under songs, form_for was not working for it
			resources :songs do
				member do
					get :configure
					get :mixaudio
					get :share_modal
          post :share
          post :toggle_like_song
          delete :toggle_like_song
          get :reload_clips
        end
				resources :parts
				resources :clip_types
				resources :clips do
          member do
            put "update_clip"
          end
					collection do
						post :state
					end
				end
			end
    end
	end

  # Normal corporate site
  constraints :subdomain => '' do
    get 'about' => 'pages#about'
    get 'news' => 'pages#news'
    get 'contact' => 'pages#contact'
    get 'artists' => 'pages#artists'
    get 'terms' => 'pages#terms'
    get 'artists/terms' => 'pages#artists_terms'
    get 'privacy' => 'pages#privacy'
    root 'pages#splash'

    # rackspace hits this url nonstop for uptime check
    match '/lbstatus' => 'pages#lbstatus', via: [:get, :options]

    get 'sign_in' => 'pages#redirect_sign_in', as: 'sign_in'

    get '/beta' => redirect('/')
  end

	# Normal site (no subdomain or www)
	constraints :subdomain => 'app' do
    namespace :app, path: '/' do
      get '/' => 'home#index', as: 'home'
      get '/install' => 'home#install', as: 'install'
      get '/welcome_modal' => 'home#welcome_modal'
      get '/reset_password_success_modal' => 'passwords#reset_password_success_modal'
      post '/resend_confirmation' => 'passwords#resend_confirmation', as: 'resend_confirmation'

      get '/sign_in' => 'sessions#new', as: 'sign_in'
      get '/sign_up' => 'users#new', as: 'sign_up'
      get '/sign_out' => 'sessions#destroy', as: 'sign_out'
      get '/auth/:provider/callback' => 'sessions#create_from_omniauth'
      get '/thanks' => 'users#thanks', as: 'sign_up_thanks'

      get '/artists/join' => 'artists#join', as: 'artists_join'
      post '/artists/join' => 'artists#join'
      get '/artists/apply' => 'artists#apply', as: 'artists_apply'
      post '/artists/apply' => 'artists#apply'
      get '/artists/thanks' => 'artists#thanks', as: 'artists_thanks'
      get '/artists/confirm' => 'artists#confirm', as: 'artists_confirm'

      # AUTHENTICATION
      resource	:session, :controller => 'sessions', :only => [:new, :create, :destroy]
      resources :passwords, :controller => 'passwords', :only => [:create, :new]
      resource	:users, controller: 'users', only: [:create] do
        member do
          get :confirm
          get :create_success
        end
        resource :password, controller: 'passwords', only: [:create, :edit, :update] do
          member do
            get :reset_password_success_modal
          end
        end
      end

      resources :songs do
        member do
          get :share_modal
          post :share
          post :toggle_like_song
          delete :toggle_like_song
        end
      end

      resources :comments

      get    '/auth/:provider/callback' => 'sessions#create_from_omniauth'
      delete 'identity/:provider/disconnect' => 'users#disconnect_identity', as: 'disconnect_identity'

      get 'referrals/:invite_code' => 'referrals#track', as: 'referral_invite'
      get 'referrals/thanks' => 'referrals#thanks'
      post 'referrals' => 'referrals#create'

      get '/:username',      to: 'users#show_profile', as: 'show_profile'
      get '/:username/edit', to: 'users#edit_profile', as: 'edit_profile'
      patch '/:username/update' => 'users#update_profile', as: 'update_profile'
      patch '/:username/update_account' => 'users#update_account', as: 'update_account'
      post '/:username/follow' => 'users#follow', as: 'follow'
      delete '/:username/unfollow' => 'users#unfollow', as: 'unfollow'
      # NOTE: nothing below this!
    end
	end

	# Admin subdomain
	constraints :subdomain => 'admin' do
		mount Sidekiq::Web => '/sidekiq'
		mount GrapeSwaggerRails::Engine => '/swagger', as: 'swagger'
		mount RailsAdmin::Engine => '/', as: 'rails_admin'
  end
end
