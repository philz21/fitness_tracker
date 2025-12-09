Rails.application.routes.draw do
  get "exercises/index"
  get "progress/index"
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # My routes
  root "entries#index"
  resources :entries
  resources :exercises, only: [:index] 

  get "progress", to: "progress#index", as: :progress
  get "exercise_images/:id", to: "exercises#image", as: :exercise_image

  if Rails.env.test?
    post '/test/cleanup', to: 'test_support#cleanup'
  end

end
