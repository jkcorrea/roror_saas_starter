# frozen_string_literal: true

# Manages all calls to Stripe pertaining to subscriptions
class SubscriptionService
  def initialize(current_account, params = {})
    @account = current_account
    @params = params
  end

  # Subscriptions are created when users complete the registration form.
  def create_subscription
    subscription = nil
    stripe_call do
      local_plan = Plan.active.find(@params[:plan_id])
      return false if local_plan.nil?
      stripe_plan = Stripe::Plan.retrieve(local_plan.stripe_id)
      # If the plan has a trial time, it does not need a stripe token to create a subscription
      # We assume you have a trial time > 0. Otherwise there will be 2 customers created for
      # each subscribed customer. One at registration and another when subscribing.
      subscription = customer.subscriptions.create(
        source: @params[:stripeToken],
        plan: stripe_plan.id,
        quantity: @account.active_users_count
      )
    end
    return false if subscription.nil?

    account_attributes_to_update = {
      stripe_customer_id: customer.id,
      stripe_subscription_id: subscription.id
    }

    @account.update(account_attributes_to_update)
  end

  # Fires when users subscribe (/subscribe), update their card (/billing) and switch plans.
  def update_subscription
    success = stripe_call do
      # Don't need this when I have the customer method
      # customer = Stripe::Customer.retrieve(@account.stripe_customer_id)
      subscription = customer.subscriptions.retrieve(@account.stripe_subscription_id)
      subscription.source = @params[:stripeToken] if @params[:stripeToken]
      # Update plan if one is provided, otherwise use user's existing plan
      plan_stripe_id = if @params[:plan_id]
                         Plan.find(@params[:plan_id]).stripe_id
                       else
                         @account.plan.stripe_id
                       end
      subscription.items = [{
        id: subscription.items.data[0].id,
        plan: plan_stripe_id,
        quantity: @account.active_users_count
      }]
      subscription.save
    end
    return false unless success
    account_attributes_to_update = {}
    # This is updated by the stripe webhook customer.updated
    # But we can update it here for a faster optimistic 'response'
    if @params[:card_last4] && @params[:stripeToken]
      account_attributes_to_update.merge!(
        card_last4: @params[:card_last4],
        card_exp_month: @params[:card_exp_month],
        card_exp_year: @params[:card_exp_year],
        card_type: @params[:card_brand]
      )
    end
    account_attributes_to_update[:plan_id] = @params[:plan_id].to_i if @params[:plan_id]
    @account.update(account_attributes_to_update) if account_attributes_to_update.any?
    return true if success
  end

  def destroy_subscription
    stripe_call do
      customer.subscriptions.retrieve(@account.stripe_subscription_id).delete
      @account.update(stripe_subscription_id: nil)
    end
  end

  private

    def customer
      @customer ||= if @account.stripe_customer_id?
                      Stripe::Customer.retrieve(@account.stripe_customer_id)
                    else
                      Stripe::Customer.create(email: @account.owner.email)
                    end
    end

    def stripe_call(&_block)
      stripe_success = false
      begin
        yield
        stripe_success = true
      # https://stripe.com/docs/api?lang=ruby#errors
      rescue Stripe::CardError => e
        Rails.logger.error(e.json_body[:error])
      rescue Stripe::RateLimitError
        Rails.logger.error 'Too many requests made to the API too quickly.'
      rescue Stripe::InvalidRequestError
        Rails.logger.error 'Invalid parameters were supplied to Stripe\'s API.'
      rescue Stripe::AuthenticationError
        Rails.logger.error 'Authentication with Stripe\'s API failed. Maybe you changed API keys recently.'
      rescue Stripe::APIConnectionError
        Rails.logger.error 'Network communication with Stripe failed.'
      rescue Stripe::StripeError
        Rails.logger.error 'Genric Stripe error.'
      end
      stripe_success
    end
end
