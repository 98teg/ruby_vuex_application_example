require 'faker'
require 'timecop'

FactoryBot.define do
  factory :user do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
    password_digest { 'foobar' }

    Timecop.freeze(Faker::Date.between(15.days.ago, 1.day.ago))

    factory :admin do
      after(:create) { |user| user.add_role(:admin) }
    end
  end

  factory :post do
    user

    title { Faker::Lorem.unique.sentence }
    content { Faker::Lorem.unique.paragraph }
  end

  factory :comment do
    user
    post

    content { Faker::Lorem.unique.paragraph }
  end
end
