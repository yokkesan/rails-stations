class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true # メールアドレスの重複も防ぐ
  validates :password, presence: true, length: { minimum: 6 }, confirmation: true, on: :create
  validates :password_confirmation, presence: true, on: :create # 確認用パスワードの存在もバリデーション
end