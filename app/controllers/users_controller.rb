# frozen_string_literal: true
class UsersController < ApplicationController
  before_action :redirect_if_logged_in,   only: [:new, :create]
  before_action :redirect_if_logged_out,  only: [:show]

  def new
    @user = User.new(user_params)
  end

  def create
    byebug
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      flash[:success] = 'Thank you for signing up'
      redirect_to action: :show
    else
      flash[:error] = 'Please complete all required info and try again'
      redirect_to action: :new
    end
  end

  def show
    @user = User.includes(:events).find(session[:user_id])
  end

private
  def user_params
    params.permit(:name)
  end
end
