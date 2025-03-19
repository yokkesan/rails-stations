Rails.application.routes.draw do
  namespace :admin do
   resources :movies, only: [:index]  # 映画一覧
  end
end
