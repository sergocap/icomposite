class UsersController < ApplicationController
  load_and_authorize_resource :only => [:edit, :update, :destroy]

  before_filter :find_user, on: [:show, :edit, :update]
  def find_user
    @user = User.find(params[:id])
  end

  def update
    @user.update_attributes(user_params)
    redirect_to user_path(@user.id)
  end

  def user_params
    params.require(:user).permit(:name, :email, :avatar)
  end
end
