Rails.application.routes.draw do
  devise_for :partners, controllers: { sessions: "partners/sessions", registrations: "partners/registrations" }, skip: [:registrations]
  devise_scope :partner do # ,  :skip => [:registrations] # do we need this?
    get "/partners/sign_out" => "devise/sessions#destroy"
    get "partners/edit" => "devise/registrations#edit", :as => "edit_partner_registration"
    put "partners" => "devise/registrations#update", :as => "partner_registration"
  end

  resources :partners do
    get :approve
  end

  resources :partner_requests, only: [:new, :create, :show, :index]

  get "/api", action: :show, controller: "api"
  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      resources :partners
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "pages/:name", to: "static#page"
  root "static#index"
end

