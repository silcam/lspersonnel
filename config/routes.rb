Rails.application.routes.draw do
  get 'languages'=>'languages#index'
  post 'languages'=>'languages#create'
  post 'people'=>'people#create'

  get 'pages/home'

  resources :people
  resources :languages
end
