BeMoreWithLess::Application.routes.draw do

  scope "api" do
    api_version = "v1"
    api_version_controller = "v1"

    get "#{api_version}/gifts", to: "#{api_version_controller}#gifts_all", defaults: {format: 'json'}
    get "#{api_version}/gifts/mine", to: "#{api_version_controller}#gifts_mine", defaults: {format: 'json'}
    get "#{api_version}/gifts/iwish", to: "#{api_version_controller}#gifts_i_wish", defaults: {format: 'json'}

    get "#{api_version}/gift/:id", to: "#{api_version_controller}#gift", defaults: {format: 'json'}
  end

  get "ios/login"

  devise_for :users, controllers: { registrations: 'registrations', omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end

  scope "(:locale)", locale: /en|es/ do
    resources :activities, only: :index
    resources :gifts, path: :items do
      collection do
        get :feed, defaults: {format: 'atom'}
      end
      member do
        put :give
      end
    end
    resources :comments
    resources :wishes
    resources :users, only: :show do
      collection do
        get :subregion_options
      end
      member do
        get :comments
        get :gifts
        get :wishes
      end
    end

    get 'categories/:category', to: 'gifts#index', as: :category
    get 'contact', to: 'pages#contact', as: :contact
    get 'how-it-works', to: 'pages#how_it_works', as: :how_it_works
    get 'addresses/subregion_options'
  end

  get 'tags/:tag', to: 'gifts#index', as: :tag
  get 'feed', to: 'gifts#feed'

  root to: 'gifts#index'
end
