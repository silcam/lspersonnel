Rails.application.routes.draw do
  root "dashboard#dash"

  resources :people do
    resources :leave, except: ["edit","update","show"]
    resources :research_permits
    resources :quarterly_reports
    resources :primary_reports
  end

  resources :leave, only: ["index"]
  resources :leave_reasons, except: ["show"]

  post 'people/:person_id/attach_language', to: 'people#attach', as: :attach_language

  resources :languages
end
