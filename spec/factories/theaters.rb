# frozen_string_literal: true

FactoryBot.define do
  factory :theater do
    name { "テスト劇場#{rand(100)}" }
  end
end
