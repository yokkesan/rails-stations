# frozen_string_literal: true

Rails.application.routes.draw do
  get 'rankings/index'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  # 映画一覧ページ（一般ユーザー向け）
  resources :movies, only: %i[index show] do
    # 追加: GET /movies/:movie_id/reservation
    get 'reservation', on: :member

    resources :schedules, only: [] do
      resources :reservations, only: [:new]
    end
  end

  # 座席一覧
  resources :sheets, only: [:index]
  # ランキング確認
  resources :rankings, only: [:index]

  # 予約登録
  resources :reservations, only: [:create]

  # 管理者用映画管理
  namespace :admin do
    resources :movies, only: %i[index new create edit update destroy show] do
      resources :schedules, only: %i[new create]
    end
    resources :schedules, only: %i[index show new update destroy edit create]
    resources :reservations
    resources :theaters
  end
  root 'movies#index'
end
