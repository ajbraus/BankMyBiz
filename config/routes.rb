BankMyBiz::Application.routes.draw do

  resources :authentications, only: [:index, :create, :destroy]

  resources :messages
  resources :posts do 
    resources :comments
    resources :answers
    member do
      get :vote_up
      get :vote_down
    end
  end

  resources :answers do
    resources :comments
    member do
      get :vote_up
      get :vote_down
    end
  end
  
  resources :comments do
    member do
      get :vote_up
      get :vote_down
    end
  end

  resources :favorites, only: [:index]

  resources :subscriptions, only: [:new, :create]
  #resources :purchases, only: [:new, :create]
  resources :likes, only: [:create, :destroy]

  match '/auth/:provider/callback' => 'authentications#create'

  resources :matches, only: [:index]

  match 'user/:id/bank', to: "users#set_bank", as: 'set_bank'
  match 'user/:id/biz', to: "users#set_business", as: 'set_business'

  resources :relationships, only: [:create, :destroy]

  authenticated :user do
    root :to => 'posts#index'
  end

  get '/news-feed' => 'posts#index', as: 'posts'

  root :to => 'welcome#index'
  match '/how-it-works', :to => 'welcome#how', :as => "how"
  match '/testimonials', :to => 'welcome#testimonials', :as => "testimonials"
  match '/terms', :to => 'welcome#terms', :as => "terms"
  match '/privacy', :to => 'welcome#privacy', :as => "privacy"
  match '/about-us', :to => 'welcome#about', :as => "about"
  match '/team', :to => 'welcome#team', :as => "team"
  match '/subscribe', :to => 'welcome#subscribe', :as => "subscribe"

  match '/posts/:id/robot_post', to: 'welcome#robot_post', as: "robot_post"

  devise_for :users, :controllers => { :registrations => "registrations", :invitations => 'invitations' } do
    match 'users/add_avatar' => 'registrations#add_avatar', as: "add_avatar"
  end

  resources :users, :only => [:show, :index, :confirm, :reject] do
    get :reject
    get :confirm
    get :interested
  end
  match 'users/:id' => 'users#show'
  match 'users/:id/profile/edit' => 'profiles#edit', as: 'edit_profile'
  match 'users/:id/profiles' => 'profiles#update', as: 'update_profile'

  resources :commitments, only: [:create, :destroy]

  get 'tags/:tag', to: 'tags#show', as: :tag





  #/api/v1/ . . . 
  namespace :api, defaults: {format: 'json'} do 
    namespace :v1 do 
      devise_for :users, :controllers => { :sessions => "api/v1/sessions", :registrations => "api/v1/registrations" }
      resources :users, only: [:show]
      #resources :tokens, :only => [:create, :destroy]
      resources :posts
      resources :messages
      resources :activities, only: [:index]
      match 'user/:id/activities', to: "activities#index"
      resources :users, only: [:show, :edit, :update, :index]
      resources :matches, only: [:create, :destroy, :index]
      resources :relationships, only: [:create, :destroy, :index]
    end
  end
end
