# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    title { "本のタイトル1" }
    memo { "本に関するメモ1" }
    author { "本の作者1" }
  end
end
