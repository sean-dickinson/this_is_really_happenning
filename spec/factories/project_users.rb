FactoryBot.define do
  factory :project_user do
    project
    user
    role { :member }

    trait :as_owner do
      role { :owner }
    end
  end
end
