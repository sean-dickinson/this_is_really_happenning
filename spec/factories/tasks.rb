FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "Task #{n}" }
    description { nil }
    association :project, factory: :valid_project
    is_active { true }
  end
end
