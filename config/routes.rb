Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/auth/login', to: 'auth#login'
  get '/auth/refresh', to: 'auth#refresh'

  namespace :api do

    get '/jsonspec/response' => 'json_spec#response_schema'
    get '/jsonspec/request' => 'json_spec#request_schema'

    jsonapi_resources :users
    jsonapi_resources :contracts
    jsonapi_resources :actions
    jsonapi_resources :entities
    jsonapi_resources :fields
    jsonapi_resources :relationships
  end

  root to: 'frontend#index'

  get '/*path' => 'frontend#index'

end
