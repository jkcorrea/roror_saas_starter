# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit
  include ActionView::Helpers::DateHelper
  include ApartmentHelper
  protect_from_forgery with: :exception
  impersonates :user
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_access, if: :access_required?

  # Pundit reminder to call authorize within actions or scope for index actions
  # rubocop:disable Rails/LexicallyScopedActionFilter
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index
  # rubocop:enable Rails/LexicallyScopedActionFilter

  # Exception handling
  rescue_from Pundit::NotAuthorizedError, with: :handle_pundit_not_authorized

  def after_sign_in_path_for(resource)
    # If subdomain isn't provided, go to users first account
    account = if request.subdomains.try(:first).nil?
                resource.accounts.order(:id).first
              else
                current_account
              end
    dashboard_url(subdomain: account.subdomain)
  end

  # Replaces 'current_user' to provide account and accounts_user in Context.
  def pundit_user
    @pundit_user ||= Context.new(
      account: current_account,
      accounts_user: current_accounts_user,
      user: current_user
    )
  end

  protected

    def configure_permitted_parameters
      added_params = %i(first_name last_name avatar plan_id)
      devise_parameter_sanitizer.permit :sign_up, keys: added_params
      devise_parameter_sanitizer.permit :account_update, keys: added_params
      devise_parameter_sanitizer.permit :accept_invitation, keys: %i(first_name last_name)
    end

    # Users are always allowed to manage their session, registration, subscription and account
    def access_required?
      user_signed_in? &&
        !devise_controller? &&
        !%w(
          subscriptions
          accounts
        ).include?(controller_name)
    end

    # Redirect users in accounts in bad standing to billing page
    def check_access
      redirect_to billing_path, flash: { error: "Your account is inactive. Access will be restored once payment succeeds." } if current_account.try(:inactive?)
    end

  private

    def handle_pundit_not_authorized(exception)
      policy = exception.policy
      record = policy.record
      message = case Rails.env
                when "development", "test"
                  "#{policy.class.name} does not allow #{exception.query} on #{record.class.name} <#{record.id}>."
                else
                  "Access denied."
                end
      flash[:error] = message
      redirect_back(fallback_location: dashboard_path)
    end
end
