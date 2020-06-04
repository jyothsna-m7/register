# frozen_string_literal: true
class Event < ApplicationRecord
  validates :user, :clock_in, presence: true
  belongs_to :user
  validates :user, uniqueness: { scope: [:clock_in, :clock_out] }
  validates :clock_in, :clock_out, present_time: true

  validate :clock_out_time, if: proc { |event| event.clock_out_changed? }
  validate :clock_in_time, if: proc { |event| event.clock_in_changed? }

  default_scope { order('clock_in desc') }

  scope :today, -> { where(clock_in: Date.today.beginning_of_day..Date.today.end_of_day).order('clock_out desc') }
  # scope :old, -> { where('clock_in < ?', Date.today.end_of_day).order('clock_out desc') }

  scope :pending, -> { where('clock_out is null') }

  def clock_in_time
    fresh_event? && no_overlap?
  end

  def fresh_event?
    pending_events = user.events.pending
    return true if pending_events.empty? || (pending_events.size == 1 && pending_events.last.id == id)

    errors['clock_in'] << 'can not be done, please clock_out the pending one'
    false
  end

  def no_overlap?
    last_event = user.events.first

    return true if last_event.clock_out.nil? || last_event.clock_out < clock_in

    errors['clock_in'] << 'time is overlapping with old events'
    false
  end

  def clock_out_time
    past_clock_in? && clock_out_overlap?
  end

  def past_clock_in?
    return true if clock_out > clock_in

    errors['clock_out'] << 'cant be before clock-in time'
    false
  end

  def clock_out_overlap?
    overlap_window = user.events.where('clock_in < ? AND clock_out > ?', clock_out, clock_out)
    overlap_pending = user.events.where('clock_in < ? AND clock_out is null', clock_out)

    if overlap_window.empty?
      valid_clock_out = true
    elsif overlap_window.size == 1 && overlap_window.first.id == id
      valid_clock_out = true
    else
      valid_clock_out = false
    end

    return true if valid_clock_out && overlap_pending.empty?

    errors['clock_out'] << 'time is overlapping with old events'
    false
  end

  def clock_in_now(now = nil)
    update_attributes(clock_in: now || Time.now)
  end

  def clock_out_now(now = nil)
    update_attributes(clock_out: now || Time.now)
  end
end
