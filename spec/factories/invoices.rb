# frozen_string_literal: true

# == Schema Information
#
# Table name: invoices
#
#  id         :uuid             not null, primary key
#  stripe_id  :string
#  amount     :integer
#  currency   :string
#  number     :string
#  paid_at    :datetime
#  lines      :text
#  account_id :uuid             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :invoice do
    association :account
    stripe_id { "asdf" }
    amount { 900 }
    currency { "usd" }
    number { "d1a9e076f5-0001" }
    paid_at { "2018-01-28 22:50:26" }
    lines { [
      {
        "id": "sub_00000000000000",
        "object": "line_item",
        "amount": 0,
        "currency": "usd",
        "description": "1x Pro",
        "discountable": false,
        "livemode": false,
        "metadata": {},
        "period": {
          "start": 1_517_179_826,
          "end": 1_518_389_426
        },
        "plan": {
          "id": "example-plan-id",
          "object": "plan",
          "amount": 1500,
          "created": 1_517_179_573,
          "currency": "usd",
          "interval": "month",
          "interval_count": 1,
          "livemode": false,
          "metadata": {},
          "name": "Pro",
          "statement_descriptor": nil,
          "trial_period_days": 14
        },
        "proration": false,
        "quantity": 1,
        "subscription": nil,
        "subscription_item": "si_00000000000000",
        "type": "subscription"
      }
    ] }
    initialize_with { Invoice.where(stripe_id: "asdf").first_or_initialize }
  end
end
