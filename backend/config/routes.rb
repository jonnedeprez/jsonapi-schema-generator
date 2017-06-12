Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/auth/login', to: 'auth#login'

  jsonapi_resources :users
  jsonapi_resources :projects

end
