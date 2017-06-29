Rails.application.routes.draw do
  root "people#dash"
  resources :people
  resources :languages
end
