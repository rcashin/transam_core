Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', :as => 'admin'

  devise_for :users, :controllers => { :sessions => "sessions", :unlocks => "unlocks", :passwords => "passwords" }

  # server static pages
  get "/pages/*id" => 'pages#show', :as => :page, :format => false
  
  # route errors to the appropriate pages
  %w( 404 403 500 ).each do |code|
    get code, :to => "errors#show", :code => code
  end

  resources :inventory, :controller => 'assets' do
      collection do
        get 'filter'
        get 'details'
        get 'new_asset'
        get 'export'
        get 'map'
        get 'spatial_filter'
      end
      member do
        get 'update_status'
        get 'copy'
      end
    resources :asset_events    
        
    resources :comments,    :only => [:create, :update, :edit, :new, :destroy]
    
    resources :images,      :only => [:create, :update, :edit, :new, :destroy] do
      member do
        get 'download'
      end
    end
    
    resources :documents,   :only => [:create, :update, :edit, :new, :destroy] do
      member do
        get 'download'
      end
    end    
  end
      
  # Provide an alias for asset paths which are discovered by form helpers such as 
  # commentable, documentable, and imagable controllers
  resources :assets, :path => :inventory do
    resources :comments
    resources :documents
    resources :images
  end
      
  resources :organizations, :path => "org", :only => [:index, :show, :edit, :update] 
  
  resources :comments,    :only => [:create, :update, :edit, :new, :destroy]    
  resources :documents,   :only => [:create, :update, :edit, :new, :destroy] do
    member do
      get 'download'
    end
  end
  resources :images,      :only => [:create, :update, :edit, :new, :destroy] do
    member do
      get 'download'
    end
  end
  
  resources :tasks do
    resources :comments
  end
  
  resources :dashboards,    :only => [:index, :show]
  resources :activity_logs, :only => [:index]
  resources :searches,      :only => [:new, :create]
  resources :reports,       :only => [:index, :show] do
    member do
      get 'load'  # load a report using ajax
    end
  end
  
  resources :uploads do
    collection do
      get   'templates'
      post  'create_template'
    end
    member do
      get   'resubmit'
    end
  end 
  
  resources :users do
    collection do
    end
    member do
      post  'set_current_org'
      get   'change_password'
      patch 'update_password'
    end
    resources :messages
    
    resources :tasks do
      resources :comments,    :only => [:create, :update, :edit, :new, :destroy]
      collection do
        get   'filter'
      end
      member do
        patch 'update_status'
      end
    end
    # Add user organization filters
    resources :user_organizations_filters
  end
      
  resources :policies do
    member do
      get   'copy'
    end
  end
  
  # default root for the site -- will be /org/:organization_id/dashboards
  root :to => 'dashboards#index'
  
end
