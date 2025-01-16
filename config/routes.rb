Rails.application.routes.draw do
  resources :applicants do
    patch :change_stage, on: :member
    get :resume, action: :show, controller: "resumes"
    resources :emails, only: %i[index new create show]
  end
  resources :jobs
  devise_for :users,
    path: "",
    controllers: {
      registrations: "users/registrations",
      sessions: "users/sessions"
    },
    path_names: {
      sign_in: "login",
      password: "forgot",
      confirmation: "confirm",
      sign_up: "sign_up",
      sign_out: "signout"
    }
  get "dashboard/show"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root to: "dashboard#show"
  authenticated :user do
    root to: "dashboard#show", as: :user_root
  end

  devise_scope :user do
    root to: "devise/sessions#new"
  end
end
