require 'faker'
require 'timecop'

FactoryBot.define do
  factory :user do
    name { Faker::JapaneseMedia::OnePiece.unique.character }
    email { Faker::Internet.unique.email }
    password_digest { 'foobar' }

    Timecop.freeze(Faker::Date.between(14.days.ago, Time.zone.today))
  end
end
