class UsersController < ApplicationController
  load_and_authorize_resource

  def update
    if @user.update_attributes user_params
      @user.check_medium_avatar
      redirect_to user_path @user.id
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :avatar, :about_my)
  end
end
