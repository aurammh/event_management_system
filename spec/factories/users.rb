FactoryBot.define do
  factory :user do
    username { "Sample User" }
    sequence :email do |n|
      "person#{n}@example.com"
    end
    password { "password" }
  end
end