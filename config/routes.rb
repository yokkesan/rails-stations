Rails.application.routes.draw do
  # 座席表

  # 映画一覧ページ（一般ユーザー向け）
  resources :movies, only: [:index, :show]  # `show` を追加して詳細ページに対応
  resources :sheets, only: [:index]  # 座席表

  # 管理者用映画管理
  namespace :admin do
    resources :movies, only: [:index, :new, :create, :edit, :update, :destroy, :show] do
      resources :schedules, only: [:new, :create]  # /admin/movies/:movie_id/schedules/new
    end
    resources :schedules, only: [:index, :show, :update, :destroy, :edit]
  end
end