# frozen_string_literal: true

class AvatarsController < ApplicationController
  before_action :set_user, only: %i(update destroy)
  before_action :set_avatar, only: %i(update destroy)
  before_action :skip_authorization
  respond_to :json
  layout false

  def update
    authorize @avatar
    if params.try(:[], :user).try(:[], :avatar).present?
      avatar_uploaded = params[:user][:avatar]
    else
      head :unauthorized && return
    end

    respond_to do |format|
      if @user.save && avatar_uploaded
        @avatar.attach(avatar_uploaded)
        format.html { redirect_to edit_user_registration_path, notice: 'Avatar updated' }
      end
    end
  end

  def destroy
    # authorize @avatar
    @avatar.purge

    respond_to do |format|
      if @user.save
        format.html { redirect_to edit_user_registration_path, notice: 'Avatar deleted' }
      end
    end
  end

  private

    def set_user
      @user = current_user
    end

    def set_avatar
      @avatar = @user.avatar || @user.avatar.new
    end

    def avatar_params
      params.require(:user).permit(:avatar)
    end
end
