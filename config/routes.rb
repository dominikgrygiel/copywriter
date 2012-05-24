Copywriter::Application.routes.draw do

  match "/auth/:provider/callback", to: "sessions#create"

  scope ":user_id" do
    resources :articles, :path => ""
  end

  match "", :to => "articles#index", :constraints => { :subdomain => /.+/ }
  root :to => "articles#index"

end
