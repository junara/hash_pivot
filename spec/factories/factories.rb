# frozen_string_literal: true

FactoryBot.define do
  factory :hash_pivot_user do
    role { 'rabbit' }
    team { 'development' }
    age { 1 }
  end
end
