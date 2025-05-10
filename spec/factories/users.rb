FactoryBot.define do
  factory :user do
    sequence(:email_address) { |n| "user#{n}@example.com" }
    password { "password123" }

    trait :with_projects do
      transient do
        projects_count { 2 }
        role { :owner }
      end

      after(:create) do |user, evaluator|
        evaluator.projects_count.times do
          project = build(:project)
          project.project_users.build(user: user, role: evaluator.role)
          project.save!
        end
      end
    end
  end
end
