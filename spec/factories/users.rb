FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    after(:build) { |u| u.skip_confirmation_notification! }
    after(:create) { |u| u.confirm }
  end
end
