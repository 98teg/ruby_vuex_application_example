require 'faker'
require 'timecop'

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password_digest { 'foobar' }

    Timecop.freeze(Faker::Date.between(15.days.ago, 1.day.ago))
  end

  factory :post do
    user

    title { Faker::JapaneseMedia::OnePiece.unique.island }
    content { Faker::JapaneseMedia::OnePiece.unique.akuma_no_mi }
  end
end
