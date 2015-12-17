require 'api_constraints'
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
        end
				resources :parts
				resources :clip_types
				resources :clips do
					collection do
						post :state
					end
				end
			end
    end
		get '/auth/:provider/callback' => 'sessions#create_from_omniauth'
	end

	# Normal site (no subdomain or www)
	constraints :subdomain => '' do
		get 'beta/artist' => 'beta_artists#join', as: 'beta_artists'
		# get 'beta/thanks' => 'beta_users#thanks', as: 'beta_artists_thanks'
		post 'beta/artist' => 'beta_artists#join'

		get 'beta/sign_up/:invite_code' => 'beta_users#new', as: 'beta_sign_up'
		post 'beta/sign_up/:invite_code' => 'beta_users#create'
		get 'beta/thanks' => 'beta_users#thanks', as: 'beta_thanks'

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
    get '/thanks' => 'users#thanks', as: 'sign_up_thanks'

		match '/lbstatus' => 'pages#lbstatus', via: [:get, :options]
	end

	get 'referrals/:invite_code' => 'referrals#track'
	get 'referrals/thanks' => 'referrals#thanks'
	post 'referrals' => 'referrals#create'

	get 'about' => 'pages#about'
	get 'news' => 'pages#news'
	get 'contact' => 'pages#contact'

	# Admin subdomain
	constraints :subdomain => 'admin' do
		mount Sidekiq::Web => '/sidekiq'
		mount GrapeSwaggerRails::Engine => '/swagger', as: 'swagger'
		mount RailsAdmin::Engine => '/', as: 'rails_admin'
	end
end
