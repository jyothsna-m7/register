# frozen_string_literal: true
class EventsController < ApplicationController
  # before_action :redirect_if_logged_in,   only: [:new, :create]
  before_action :redirect_if_logged_out,  only: [:create]

  def update; end

  def create
    byebug
    puts 'haha'
    @user = User.find(params[:user_id])
    @event = @user.events.new

    if @event.clock_in_now(parsed_clock_in)
      flash[:success] = 'Successfully Clocked in!'
    else
      flash[:error] = @event.errors.full_messages.join(', ')
    end
    redirect_to user_path
  end

  def update
    byebug
    puts 'hehe'
    @event = Event.find(params[:id])

    if @event.clock_out_now(parsed_clock_out)
      flash[:success] = 'Successfully Clocked out!'
    else
      flash[:error] = @event.errors.full_messages.join(', ')
    end
    redirect_to user_path
  end

  def destroy
    byebug
    @event = Event.find(params[:id])

    if @event.destroy
      flash[:success] = 'Successfully deleted the event'
    else
      flash[:error] = @event.errors.full_messages.join(', ')
    end
    redirect_to user_path
  end

  private

  def event_params
    params.permit(:clock_out, :clock_in)
  end

  def parsed_clock_in
    return unless params[:clock_in].present?

    Time.new(*params[:clock_in].values)
  end

  def parsed_clock_out
    return unless params[:clock_out].present?

    Time.new(*params[:clock_out].values)
  end
end
