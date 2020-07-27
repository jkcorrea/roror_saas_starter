# frozen_string_literal: true

# == Schema Information
#
# Table name: public.plans
#
#  id        :uuid             not null, primary key
#  name      :string           not null
#  amount    :integer          not null
#  currency  :string           not null
#  interval  :string           not null
#  stripe_id :string           not null
#  active    :boolean          default(TRUE), not null
#
require "rails_helper"
require "stripe_mock"

RSpec.describe Plan, type: :model do
  let(:stripe_helper) { StripeMock.create_test_helper }
  before do
    StripeMock.start
  end
  after { StripeMock.stop }

  describe "validations" do
    it "has a valid factory" do
      expect(build(:plan)).to be_valid
    end

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:amount) }
  end

  describe "cost" do
    it "returns a human readble amount" do
      expect(build(:plan).cost).to eq "$1,000.00 USD"
    end
  end
end
