FactoryBot.define do
  factory :check_in do
    association :task
    metadata { nil }
  end
end
