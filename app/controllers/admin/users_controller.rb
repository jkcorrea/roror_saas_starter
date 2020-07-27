# frozen_string_literal: true

module Admin
  class UsersController < Admin::ApplicationController
    def impersonate
      user = User.find(params[:id])
      impersonate_user(user)
      redirect_to dashboard_path
    end

    def stop_impersonating
      stop_impersonating_user
      redirect_to admin_users_path
    end
  end
end
