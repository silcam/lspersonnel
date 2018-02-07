Rails.application.routes.draw do
  root "dashboard#dash"

  # Sessions
  get     'not_allowed',              to: 'people#not_allowed'
  get     '/login',                   to: 'sessions#new'
  delete  '/logout',                  to: 'sessions#destroy'
  get     '/auth/:provider/callback', to: 'sessions#create'
  get     '/auth/failure',            to: redirect('/')
  get     '/language/toggle',         to: 'sessions#lang_toggle'

  resources :people do
    resources :leave, except: ["edit","update","show"]
    resources :research_permits
    resources :quarterly_reports
    resources :primary_reports
    resources :documents, only: ["index"]
    get 'documents/first_request', to: 'documents#first_request', as: 'first_request_doc'
    get 'documents/primary_report', to: 'documents#primary_report', as: 'primary_report_doc'
    get 'documents/renew_permit', to: 'documents#renew_permit', as: 'renew_permit_doc'
    get 'documents/new_primary_report', to: 'documents#new_primary_report', as: 'new_primary_report_doc'
  end

  post 'people/:person_id/attach_language', to: 'people#attach', as: :attach_language

  resources :leave, only: ["index"]
  resources :leave_reasons, except: ["show"]
  resources :titles, except: ["show"]
  resources :nationalities, except: ["show"]
  resources :directors, except: ["show"]
  resources :languages
end
