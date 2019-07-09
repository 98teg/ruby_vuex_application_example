require 'faker'
require 'timecop'

FactoryBot.define do
  factory :user do
    name { Faker::JapaneseMedia::OnePiece.unique.character }
    email { Faker::Internet.unique.email }
    password_digest { 'foobar' }

    Timecop.freeze(Faker::Date.between(15.days.ago, 1.day.ago))
  end

  factory :post do
    user

    title { Faker::JapaneseMedia::OnePiece.unique.quote }
    content { Faker::GreekPhilosophers.unique.quote }
  end
end
