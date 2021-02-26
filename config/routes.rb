Rails.application.routes.draw do
  root to: 'welcome#index'
  get '/oauth2-callback', to: 'o_auth#oauth_callback'
  get '/logout', to: 'o_auth#logout'
  get '/login', to: 'o_auth#login'
  get '/register', to: 'o_auth#register'
  post '/registration_webhook', to: 'registration_webhook#handle_registration'
end
