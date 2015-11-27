require 'api_constraints'

Rails.application.routes.draw do

	# API subdomain
	constraints :subdomain => 'api' do
		namespace :api, path:'/', defaults: {format: :json} do
			scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true) do
				# root to: "sessions#new"
				get '/app/install' => 'app#install'
				get '/app/startup' => 'app#startup'

				post '/users/signup' => 'users#signup'
				post '/users/login' => 'users#login'
				post '/users/logout' => 'users#logout'
			  post '/users/connect' => 'users#connect'

				get '/social/stream' => 'social#stream'

				post '/publish/mix'		=> 'publish#mix'
				post '/publish/audio' => 'publish#audio'

				resources :songs, :only => [:index, :show]

#				resources :users, :only => [:show, :create]
#				resources :sessions, :only => [:create, :destroy]
#				resource	:session, :controller => 'sessions', :only => [:new, :create, :destroy]
			end
		end
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
			get 'music' => 'artist#music', as: 'music'
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
        end
				resources :parts
				resources :clips do
					collection do
						post :state
					end
				end
			end
		end
	end

	# Normal site (no subdomain or www)
	constraints :subdomain => '' do
		get 'beta/artist' => 'beta_artists#join', as: 'beta_artists'
		# get 'beta/thanks' => 'beta_users#thanks', as: 'beta_artists_thanks'
		post 'beta/artist' => 'beta_artists#join'

		get 'beta/join' => 'beta_users#join', as: 'beta_users'
		get 'beta/thanks' => 'beta_users#thanks', as: 'beta_thanks'
		post 'beta/join' => 'beta_users#join'

		# You can have the root of your site routed with "root"
		root 'pages#splash'

		# AUTHENTICATION
		resource	:session, :controller => 'sessions', :only => [:new, :create, :destroy]
		resources :passwords, controller: 'passwords', only: [:create, :new]
		resource	:users, controller: 'users', only: [:create] do
			resource :password, controller: 'passwords', only: [:create, :edit, :update]
		end
		get '/sign_in' => 'sessions#new', as: 'sign_in'
		get '/sign_up' => 'users#new', as: 'sign_up'
		get '/sign_out' => 'sessions#destroy', as: 'sign_out'
		get '/auth/:provider/callback' => 'sessions#create_from_omniauth'

		match '/lbstatus' => 'pages#lbstatus', via: [:get, :options]
	end

	# ADMIN
	constraints :subdomain => 'admin' do
		mount RailsAdmin::Engine => '/', as: 'rails_admin'
	end

	require 'sidekiq/web'
	mount Sidekiq::Web => '/sidekiq'
end
