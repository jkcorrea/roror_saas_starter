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
require "stripe_mock"

FactoryBot.define do
  factory :plan do
    name { "World Domination" }
    amount { 100_000 }
    interval { "month" }
    currency { "usd" }
    stripe_id { "example-plan-id" }
    initialize_with { Plan.where(name: name).first_or_initialize }
  end
end
