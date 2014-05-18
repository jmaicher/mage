MageWeb::Application.routes.draw do
  
  root "home#index"
  
  resource :backlog, only: :show, controller: :product_backlog do
    post 'insert', action: :insert, as: :insert
  end

  resources :backlog_items, only: [:new, :create]

  namespace :api, constraints: { format: 'json' }, defaults: { format: 'json' } do
    match '*path', :controller => 'application', :action => 'handle_options_request', via: [:options], :constraints => {:method => 'OPTIONS'}
    resource :backlog, only: :show, controller: :product_backlog

    resources :sessions, only: [:create] do
    end

    resources :meetings, only: [:index, :show, :create] do
      scope :module => :meetings do
        resources :participations, only: [:create]
        resources :poker_sessions, only: [:create]
      end
    end

    resources :devices, only: [:show]

    namespace :devices do
    
      resources :sessions, only: [:create]

      namespace :sessions do
        resources :pins, only: [:create]
      end

    end

    resources :backlog_items, only: [:show] do
      resources :taggings, only: [:index, :show, :create, :destroy], controller: 'backlog_items/taggings'
    end

    resources :ideas, only: [:index, :create]
  end

  devise_for :users
  # This is actually needed so that devise creates a mapping for devices
  # (doesn't really make sense, but whatever :-)
  devise_for :device, only: []

  # Test routes
  get 'home/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
