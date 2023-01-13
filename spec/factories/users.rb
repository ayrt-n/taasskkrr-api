FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    # Skip sending email confirmation and manually confirm the user account
    after(:build) { |u| u.skip_confirmation_notification! }
    after(:create) { |u| u.confirm }
  end
end
