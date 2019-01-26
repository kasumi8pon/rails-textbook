# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { "password" }

    trait :sign_up_with_facebook do
      provider { "facebook" }
      sequence(:uid) { |n| n }
    end
  end
end
