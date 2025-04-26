Rails.application.routes.draw do
  devise_for :users, controllers: {
  registrations: 'users/registrations'
}
  # 映画一覧ページ（一般ユーザー向け）
  resources :movies, only: [:index, :show] do
    # 追加: GET /movies/:movie_id/reservation
    get 'reservation', on: :member

    resources :schedules, only: [] do
      resources :reservations, only: [:new]
    end
  end

  # 座席一覧
  resources :sheets, only: [:index]

  # 予約登録
  resources :reservations, only: [:create]

  # 管理者用映画管理
  namespace :admin do
    resources :movies, only: [:index, :new, :create, :edit, :update, :destroy, :show] do
      resources :schedules, only: [:new, :create]
    end
    resources :schedules, only: [:index, :show, :update, :destroy, :edit]
    resources :reservations
  end
  root "movies#index"
end