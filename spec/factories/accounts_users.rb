# frozen_string_literal: true

# == Schema Information
#
# Table name: public.accounts_users
#
#  id           :uuid             not null, primary key
#  role         :integer          default("admin"), not null
#  account_id   :uuid             not null
#  user_id      :uuid             not null
#  discarded_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :accounts_user do
    association :account
    association :user

    trait :admin do
      role { "admin" }
    end
    trait :user do
      role { "user" }
    end

    trait :subscribed do
      association :account, :subscribed
    end
  end
end
