# frozen_string_literal: false

subdomain = "mantledb"

unless Rails.env.test?
  if Apartment::Tenant.current === "public"
    price_ids = ENV["STRIPE_PRICE_IDS"].strip.split(" ")
    plans = price_ids.map { |id| Plan.find_or_create_by!({ stripe_id: id }) }
    Rails.logger.info "LOADED PRICES: #{plans.map { |p| "#{p.name} (#{p.stripe_id})" }.join(', ')}"

    proj_name = ENV["COMPOSE_PROJECT_NAME"]
    account = Account.find_or_create_by!({
      name: proj_name.camelize,
      subdomain: subdomain,
      plan_id: plans.first.id,
      current_period_end: 5.years.from_now,
      trialing: false,
      past_due: false,
      unpaid: false,
      cancelled: false
    })
    Rails.logger.info "CREATED ACCOUNT: #{account.name}"

    admin_user = CreateAdminService.new(subdomain).call
    Rails.logger.info "CREATED ADMIN USER: #{admin_user.email}"
  end
else
  puts "SKIPPED PRICE, ACCOUNT, AND ADMIN CREATION BECAUSE WE'RE IN TEST."
end
