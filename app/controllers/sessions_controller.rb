class SessionsController < ApplicationController
  before_action :redirect_if_logged_in,   only: [:new, :create]
  before_action :redirect_if_logged_out,  only: [:destroy]

  def new; end

  def create
    @user = User.find_or_initialize_by(name: sanitize_params)

    if @user.save
      session[:user_id] = @user.id
      flash[:success] = 'You are logged in'
      redirect_to user_path
    else
      flash[:error] = 'Failed to log in, please try again'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = 'You are now logged out'
    render :new
  end

  private

  def sanitize_params
    # FIXME: Move this logic to resuable string method
    permit_params
    params[:name].downcase.squish
  end

  def permit_params
    params.permit(:name)
  end
end
