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
require "rails_helper"

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(create(:user)).to be_valid
  end

  # Validations
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }
  it { is_expected.to allow_value("email@address.foo").for(:email) }
  it { is_expected.to_not allow_value("email").for(:email) }
  it { is_expected.to_not allow_value("email@domain").for(:email) }
  it { is_expected.to_not allow_value("email@domain.").for(:email) }
  it { is_expected.to_not allow_value("email@domain.a").for(:email) }

  # Callbacks
  describe "#set_full_name" do
    it "sets the full_name" do
      expect(create(:user).full_name).to_not be_empty
    end
  end

  # Methods
  describe "#flipper_id" do
    it "returns namespaced id" do
      expect(create(:user).flipper_id).to match /User;/
    end
  end
end
