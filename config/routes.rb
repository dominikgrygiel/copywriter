Copywriter::Application.routes.draw do

  scope ":user_id" do
    resources :articles, :path => ""
  end

  match "", :to => "articles#index", :constraints => { :subdomain => /.+/ }
  root :to => "articles#index"

end
