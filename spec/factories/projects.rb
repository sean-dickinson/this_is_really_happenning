FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    owners { [association(:user)] }
  end
end
