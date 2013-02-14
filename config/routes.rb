Nogent::Application.routes.draw do
  resources :sessions, :only => [:create]
  resources :registrations, :only => [:create]
  get '/signin' => 'sessions#new' ,:as => :signin
  get '/signout' => 'sessions#destroy' ,:as => :signout
  get '/signup' => 'registrations#new', :as => :signup
  root :to => 'sessions#new'
end
