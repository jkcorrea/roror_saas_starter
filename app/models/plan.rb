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
# This model is not meant to sync with Stripe -
# just to hold the unique stripe_id as a convenience for retrieval.
# TODO Plans should be loaded by Product first, so they fall in the correct "buckets"
class Plan < ApplicationRecord
  include CurrencyHelper
  validates :name, presence: true
  validates :amount, presence: true
  before_validation :load_plan_from_stripe

  scope :active, -> { where(active: true) }

  include ActionView::Helpers::NumberHelper

  def cost
    formatted_amount(amount, currency)
  end

  private

    def load_plan_from_stripe
      # stripe_id is populated by factory in tests
      unless Rails.env.test?
        LoadPlanService.new(self).call
      end
    end
end
