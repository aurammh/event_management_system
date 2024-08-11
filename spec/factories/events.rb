FactoryBot.define do
  factory :event do
    name { "Sample Event" }
    location { "Sample Location" }
    date { DateTime.now + 1.day }
    description { "This is a sample event description." }
    association :creator, factory: :user
    end
end
