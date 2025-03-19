Rails.application.routes.draw do
  namespace :admin do
   resources :movies, only: [:index, :new, :create, :edit, :update]  # 映画一覧
  end
end
