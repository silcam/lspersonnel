Rails.application.routes.draw do
  get 'pages/home'

  resources :people
  resources :languages
end
