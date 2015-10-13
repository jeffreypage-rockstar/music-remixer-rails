Rails.application.routes.draw do

  get 'artist/join' => 'beta_artists#join', as: 'artist_join'
  get 'artist/thanks' => 'beta_artists#thanks', as: 'artist_thanks'
  post 'artist/join' => 'beta_artists#join'

  get 'user/join' => 'beta_users#join', as: 'user_join'
  get 'user/thanks' => 'beta_users#thanks', as: 'user_thanks'
  post 'user/join' => 'beta_users#join'

  get 'artist/profile'
  get 'artist/dashboard'
  get 'artist/music'
  get 'artist/connect'

  # You can have the root of your site routed with "root"
  root 'pages#splash'

	# ADMIN
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # AUTHENTICATION
  resource  :session, :controller => 'sessions', :only => [:new, :create, :destroy]
  resources :passwords, controller: 'passwords', only: [:create, :new]
  resource :users, controller: 'users', only: [:create] do
    resource :password, controller: 'passwords', only: [:create, :edit, :update]
  end
  get '/sign_in' => 'sessions#new', as: 'sign_in'
  get '/sign_up' => 'users#new', as: 'sign_up'
  delete '/sign_out' => 'sessions#destroy', as: 'sign_out'

  # SONGS
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

  # get '/configure/:id' => 'home#configure', as: :configurator
  get 'home/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
