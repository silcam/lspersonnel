Rails.application.routes.draw do
  get 'languages/index'

  get 'pages/home'

  resources :people
  resources :languages
end
