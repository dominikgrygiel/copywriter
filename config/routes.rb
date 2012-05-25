Copywriter::Application.routes.draw do

  match "/auth/:provider/callback", to: "sessions#create"

  match "/*path", :constraints => { :subdomain => /.+/ }, :to => redirect { |params, req| "http://copywriter.ihoshi.pl/#{params[:path]}" }
  scope ":user_id" do
    resources :articles, :path => ""
  end

  match "", :to => "articles#index", :constraints => { :subdomain => /.+/ }
  root :to => "articles#index"

end
