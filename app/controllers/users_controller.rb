# frozen_string_literal: true
class UsersController < ApplicationController
  # before_action :redirect_if_logged_in,   only: [:new, :create]
  before_action :redirect_if_logged_out, only: [:show]

  def show
    @user = User.includes(:events).find(session[:user_id])
  end
end
