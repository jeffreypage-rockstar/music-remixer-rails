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
			get 'dashboard' => 'artist#dashboard', as: 'dashboard'
			get 'music' => 'artist#music', as: 'music'
			get 'connect' => 'artist#connect', as: 'connect'

			# had to move parts out from under songs, form_for was not working for it
			resources :songs do
				member do
					get :configure
					get :mixaudio
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

	# get '/configure/:id' => 'home#configure', as: :configurator
	# get 'home/index'

	# The priority is based upon order of creation: first created -> highest priority.
	# See how all your routes lay out with "rake routes".

	# Example of regular route:
	#	 get 'products/:id' => 'catalog#view'

	# Example of named route that can be invoked with purchase_url(id: product.id)
	#	 get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

	# Example resource route (maps HTTP verbs to controller actions automatically):
	#	 resources :products

	# Example resource route with options:
	#	 resources :products do
	#		 member do
	#			 get 'short'
	#			 post 'toggle'
	#		 end
	#
	#		 collection do
	#			 get 'sold'
	#		 end
	#	 end

	# Example resource route with sub-resources:
	#	 resources :products do
	#		 resources :comments, :sales
	#		 resource :seller
	#	 end

	# Example resource route with more complex sub-resources:
	#	 resources :products do
	#		 resources :comments
	#		 resources :sales do
	#			 get 'recent', on: :collection
	#		 end
	#	 end

	# Example resource route with concerns:
	#	 concern :toggleable do
	#		 post 'toggle'
	#	 end
	#	 resources :posts, concerns: :toggleable
	#	 resources :photos, concerns: :toggleable

	# Example resource route within a namespace:
	#	 namespace :admin do
	#		 # Directs /admin/products/* to Admin::ProductsController
	#		 # (app/controllers/admin/products_controller.rb)
	#		 resources :products
	#	 end
end
