Rails.application.routes.draw do
# 映画一覧ページ（一般ユーザー向け）
  resources :movies, only: [:index]
  
  namespace :admin do
   resources :movies, only: [:index, :new, :create, :edit, :update, :destroy] 
  end
end
