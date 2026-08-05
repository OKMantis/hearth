Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  resource :session, controller: "sessions", only: %i[new create destroy]

  root "rooms#index"
end
