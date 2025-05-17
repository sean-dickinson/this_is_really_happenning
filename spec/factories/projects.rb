FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }

    # By default, don't create any associations

    trait :with_owner do
      transient do
        owner { nil }
      end

      after(:build) do |project, evaluator|
        if evaluator.owner
          project.project_users.build(user: evaluator.owner, role: :owner)
        else
          project.project_users.build(user: create(:user), role: :owner)
        end
      end
    end

    # This ensures the project is valid by creating an owner when the project is created
    factory :valid_project do
      with_owner
    end
  end
end
