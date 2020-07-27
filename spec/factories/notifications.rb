# frozen_string_literal: true

# == Schema Information
#
# Table name: notifications
#
#  id                 :uuid             not null, primary key
#  action             :string
#  target_name_cached :string
#  target_path_params :json
#  read               :boolean          default(FALSE), not null
#  sender_id          :uuid
#  recipient_id       :uuid
#  notifiable_type    :string
#  notifiable_id      :uuid
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  factory :notification do
    association :sender, factory: :user
    association :recipient, factory: :user
    action { "example" }
    association :notifiable, factory: :user
    target_name_cached { "Example notification" }
    target_path_params {}
    read { false }
  end
end
