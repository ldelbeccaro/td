FactoryGirl.define do
  factory :todo do
    trait :due_in_future do
      due_date { 2.days.from_now }
    end

    trait :due_in_past do
      due_date { 2.days.ago }
    end

    trait :due_today do
      due_date { Date.today }
    end

    trait :completed_in_past do
      complete_date { 2.days.ago }
    end

    trait :completed_today do
      complete_date { Date.today }
    end
  end
end
