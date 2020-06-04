class SessionsController < ApplicationController
  before_action :redirect_if_logged_in,   only: [:new, :create]
  before_action :redirect_if_logged_out,  only: [:destroy]

  def new; end

  def create
    @user = User.where('lower(name) = ?', session_params[:name]).first

    if @user
      session[:user_id] = @user.id
      flash[:success] = 'You are logged in'
      redirect_to user_path
    else
      flash[:error] = 'Failed to log in, please try again'
      redirect_to new_session_path
    end
  end

  def destroy
    byebug
    session[:user_id] = nil
    flash[:success] = "You are now logged out"
    redirect_to new_session_path
  end

  private
  def session_params
    params.permit(:name)
  end
end
