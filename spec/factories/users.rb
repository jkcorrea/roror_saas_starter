# frozen_string_literal: true

# == Schema Information
#
# Table name: public.users
#
#  id                     :uuid             not null, primary key
#  email                  :string           not null
#  first_name             :string
#  last_name              :string
#  full_name              :string
#  encrypted_password     :string
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  super_admin            :boolean          default(FALSE), not null
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invitations_count      :integer          default(0), not null
#  invited_account_id     :uuid
#  invited_by_id          :uuid
#  discarded_at           :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  provider_type          :string
#  provider_id            :string
#
FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email {  Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    invitation_accepted_at { Time.current } # Users who signed up for the account get this assigned in AccountsUsersController#create
    initialize_with { User.where(email: email).first_or_initialize }

    trait :super_admin do
      super_admin { true }
    end

    trait :invited do
      password { nil }
      password_confirmation { nil }
      invitation_created_at { Time.now.utc }
      invitation_sent_at { Time.now.utc }
      invitation_accepted_at { nil }
    end
  end
end
