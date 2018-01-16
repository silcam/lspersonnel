Rails.application.routes.draw do
  root "dashboard#dash"

  resources :people
  post 'people/:person_id/attach_language', to: 'people#attach', as: :attach_language

  resources :languages
end
