Copywriter::Application.routes.draw do

  resources :articles

  match "", :to => "articles#index", :constraints => { :subdomain => /.+/ }
  root :to => "articles#index"

end
