Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/', to: 'health#i_am_alive'

  post '/auth/login', to: 'auth#login'
  get '/auth/refresh', to: 'auth#refresh'

  get '/jsonspec/response' => 'json_spec#response_schema'
  get '/jsonspec/request' => 'json_spec#request_schema'

  jsonapi_resources :users
  jsonapi_resources :contracts
  jsonapi_resources :actions
  jsonapi_resources :entities
  jsonapi_resources :fields

end
