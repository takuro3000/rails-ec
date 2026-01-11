# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { "テストユーザー" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
  end
end
