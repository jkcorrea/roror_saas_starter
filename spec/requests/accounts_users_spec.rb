# frozen_string_literal: true

require "rails_helper"
require "stripe_mock"

RSpec.describe AccountsUsersController, type: :request do
  let(:stripe_helper) { StripeMock.create_test_helper }
  before do
    StripeMock.start
    stripe_helper.create_plan(
      id: "example-plan-id",
      name: "Pro",
      amount: 1500,
      currency: "usd",
      trial_period_days: TRIAL_PERIOD_DAYS
    )
    # Allow public registration before testing it
    Flipper.enable :public_registration
  end

  let(:au) { create(:accounts_user, :subscribed) }
  let(:account) { au.account }
  let(:user) { au.user }

  let(:admin_au) { create(:accounts_user, :admin, account: account) }
  let(:admin) { admin_au.user }

  let(:delete_au) { create(:accounts_user, account: account) }

  before do
    host! "#{account.subdomain}.lvh.me:3000"
  end

  describe "#destroy" do
    subject do
      delete accounts_user_destroy_path(delete_au.id)
      response
    end

    context "as an admin" do
      before { sign_in admin }

      it "deletes the user" do
        allow(AccountsUser).to receive(:find).with(
          delete_au.id.to_s
        ).and_return delete_au
        expect(delete_au).to receive(:discard).with(no_args).once
        subscription_service_dbl = double(SubscriptionService)
        expect(SubscriptionService).to receive(:new).with(
          account
        ).and_return subscription_service_dbl
        expect(subscription_service_dbl).to receive(:update_subscription).once
        expect(subject).to redirect_to(account_show_path)
        expect(flash[:success]).to match /has been removed from your account/
      end
    end

    context "as not an admin" do
      before { sign_in user }

      it "raises Pundit::NotAuthorizedError" do
        expect(subject).to redirect_to(dashboard_path)
        expect(flash[:alert]).to match /Access denied/
      end
    end
  end
end
