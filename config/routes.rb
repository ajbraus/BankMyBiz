BankMyBiz::Application.routes.draw do
  resources :milestones
  resources :products, only: [:show]

  match '/deposits', to: 'products#deposits', as: 'deposits'
  match '/credit-cards', to: 'products#credit_cards', as: 'credit_cards'
  match '/term-loan', to: 'products#term_loan', as: 'term_loan'
  match '/line-of-credit', to: 'products#line_of_credit', as: 'line_of_credit'
  match '/sba-loan', to: 'products#sba_loan', as: 'sba'

  match '/factoring', to: 'products#factoring', as: 'factoring'
  match '/grants', to: 'products#grants', as: 'grants'
  match '/revenue-based', to: 'products#revenue_based', as: 'revenue_based'
  match '/asset-based-financing', to: 'products#asset_based', as: 'asset_based'
  match '/private-equity', to: 'products#private_equity', as: 'private_equity'
  match '/community-development-fund', to: 'products#community_development_fund', as: 'community_development_fund'
  match '/crowd-funding-for-rewards', to: 'products#crowd_funding_for_rewards', as: 'crowd_funding_for_rewards'
  match '/merchant-cash-advance', to: 'products#merchant_cash_advance', as: 'merchant_cash_advance'
  match '/cash-advance-financing', to: 'products#cash_advance', as: 'cash_advance'
  match '/equipment-loan', to: 'products#equipment_loan', as: 'equipment_loan'

  match '/angel-investment', to: 'products#angel_investment', as: 'angel_investment'
  match '/venture-capital', to: 'products#venture_capital', as: 'venture_capital'
  match '/crowd-funding-for-equity', to: 'products#crowd_funding_for_equity', as: 'crowd_funding_for_equity'


  resources :authentications, only: [:index, :create, :destroy]

  resources :sitemaps, :only => :show
  match "/sitemap.xml", :controller => "sitemaps", :action => "show", :format => :xml

  resources :messages
  resources :posts do 
    resources :comments
    resources :answers
    member do
      get :vote_up
      get :vote_down
    end
  end

  get '/advice' => 'posts#index'

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

  resources :email_unsubscriptions, only: [:new, :create]

  resources :favorites, only: [:index]

  resources :tags, only: [:index, :create]
  get 'tags/:tag', to: 'tags#show', as: :tag

  resources :subscriptions, only: [:new, :create]
  resources :purchases, only: [:new, :create]
  resources :likes, only: [:create, :destroy]

  match '/auth/:provider/callback' => 'authentications#create'

  resources :matches, only: [:index]

  match 'user/:id/bank', to: "users#set_bank", as: 'set_bank'
  match 'user/:id/biz', to: "users#set_business", as: 'set_business'

  resources :relationships, only: [:create, :destroy]

  authenticated :user do
    root :to => 'posts#index'
  end

  root :to => 'welcome#index'
  match '/how-it-works', :to => 'welcome#how', :as => "how"
  match '/testimonials', :to => 'welcome#testimonials', :as => "testimonials"
  match '/terms', :to => 'welcome#terms', :as => "terms"
  match '/privacy', :to => 'welcome#privacy', :as => "privacy"
  match '/about-us', :to => 'welcome#about', :as => "about"
  match '/team', :to => 'welcome#team', :as => "team"

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
