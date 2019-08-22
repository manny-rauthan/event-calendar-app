Rails.application.routes.draw do
  resources :events, :only => ['create','destroy'] 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => "application#index"
end
