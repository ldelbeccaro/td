FactoryGirl.define do
  factory :recurring_todo do
    trait :daily do
      recurring_interval_unit :day
      recurring_interval_unit_number 1
    end

    trait :weekly do
      recurring_interval_unit :week
      recurring_interval_unit_number 1
      recurring_interval_days [1]
    end

    trait :monthly do
      recurring_interval_unit :month
      recurring_interval_unit_number 1
      recurring_interval_days [1]
    end

    trait :yearly do
      recurring_interval_unit :year
      recurring_interval_unit_number 1
    end

    trait :on_schedule do
      recurring_type 'on schedule'
    end

    trait :after_completion do
      recurring_type 'after completion'
    end
  end
end
