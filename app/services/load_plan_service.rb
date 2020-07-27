# frozen_string_literal: true

class LoadPlanService
  def initialize(plan_model)
    @plan_model = plan_model
  end

  def call
    plan = nil
    begin
      plan = Stripe::Plan.retrieve(@plan_model.stripe_id)
    rescue Stripe::InvalidRequestError => e
      Rails.logger.error "Error loading plan #{@plan_model.stripe_id}: #{e}"
      raise ActiveRecord::RecordInvalid
    end

    product = nil
    begin
      product = Stripe::Product.retrieve(plan.product)
    rescue Stripe::InvalidRequestError => e
      Rails.logger.error "Error loading product #{plan.product}: #{e}"
      raise ActiveRecord::RecordInvalid
    end

    @plan_model.name      = product.name
    @plan_model.amount    = plan.amount
    @plan_model.currency  = plan.currency
    @plan_model.interval  = plan.interval
    @plan_model.active    = plan.active
  end
end
