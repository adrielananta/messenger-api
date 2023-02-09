Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post "messages", to: "messages#create"
  resources :conversations do
    resources :messages, only: [:index]
  resources :conversations, only: [:index, :show]
  end
end
