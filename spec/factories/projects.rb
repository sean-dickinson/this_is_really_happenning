FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    account { association(:account) }
  end
end
