MageDesktop::Application.routes.draw do
  root "dashboard#show"
  
  resource :backlog, only: :show, controller: :product_backlog do
    post 'insert', action: :insert, as: :insert
  end

  resources :backlog_items, only: [:show, :new, :create, :edit, :update]

  resources :tags, only: [:show]

  resources :sprints, only: [:index, :show, :new, :edit, :update]

  namespace :api, constraints: { format: 'json' }, defaults: { format: 'json' } do
    match '*path', :controller => 'application', :action => 'handle_options_request', via: [:options], :constraints => {:method => 'OPTIONS'}
    resource :backlog, only: :show, controller: :product_backlog
    
    get 'dashboard' => 'dashboard#dashboard'

    resources :sprints, only: [] do
      scope :module => :sprints do
        resource :backlog, only: :show, controller: :sprint_backlog do 
          resources :items, only: [:create], controller: :sprint_backlog_items do
            resources :tasks, only: [:create, :update]
          end
        end # backlog

        resource :charts, only: [] do
          get :burndown
        end
      end
    end

    resources :sessions, only: [:create] do
    end

    resources :meetings, only: [:index, :show, :create] do
      scope :module => :meetings do
        resources :participations, only: [:create]
        resources :poker_sessions, only: [:show, :create] do
          resources :rounds, only: [:create], controller: :poker_sessions, action: :create_round
          resources :votes, only: [:create], controller: :poker_sessions, action: :create_vote
          resource :result, only: [:show], controller: :poker_sessions, action: :result
          resource :decision, only: [:create], controller: :poker_sessions, action: :complete
        end
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
      resources :acceptance_criteria, only: [:create, :update], controller: 'backlog_items/acceptance_criteria'
    end

    resources :notes, only: [:index, :create]
  end

  devise_for :users
  # This is actually needed so that devise creates a mapping for devices
  # (doesn't really make sense as we dont need devise routes for devices, but whatever :-)
  devise_for :device, only: []
end
