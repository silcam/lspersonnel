Rails.application.routes.draw do
  get 'add_language'=>'add_language#index'
  get 'add_person'=>'add_person#index'
  get 'pages'=>'pages#home'
 

  #route for languages views
  get 'languages'=>'languages#index'


  post 'add_language'=>'add_language#create'
  post 'add_person'=>'add_person#create'
  post 'pages'=>'pages#home'
  

  

  resources :people
  resources :languages
  root 'pages#home'
end
