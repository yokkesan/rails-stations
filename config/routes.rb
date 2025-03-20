Rails.application.routes.draw do
  namespace :admin do
   resources :movies, only: [:index, :new, :create, :edit, :update, :destroy] 
  end
end
