class SessionsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:destroy]
  
  def new
    @user = User.new
  end

  def create
    user = User.find_for_login(user_params[:username])
    if user
      log_in(user.id)
      redirect_to rooms_path
    else
      redirect_to login_path, flash[:notice] =  {username: ["doesn't exist"]}
    end
  end

  def destroy
    reset_session
    cookies.delete :user_id if cookies.signed[:user_id]
    redirect_to root_path
  end

  private

    def user_params
      params.require(:user).permit(:username)
    end
end
