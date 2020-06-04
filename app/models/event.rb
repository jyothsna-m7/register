# frozen_string_literal: true
class Event < ApplicationRecord
  validates :user, presence: true
  belongs_to :user
  validates :user, uniqueness: { scope: [:clock_in, :clock_out] }
  validates :clock_in, :clock_out, present_time: true

  validate :clock_out_time, if: proc { |event| event.clock_out_changed? }
  validate :clock_in_time, if: proc { |event| event.clock_in_changed? }

  scope :today, -> { where(clock_in: Date.today.beginning_of_day..Date.today.end_of_day).order('clock_out desc') }
  # scope :yesterday, -> { where(clock_in: Date.yesterday.beginning_of_day..Date.yesterday.end_of_day) }
  scope :old, -> { where('clock_in < ?', Date.yesterday.beginning_of_day).order('clock_out desc') }

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
    last_event = user.events.today.first

    return true if last_event.nil? || last_event.clock_out < clock_in

    errors['clock_in'] << 'time is overlapping with old events'
    false
  end

  def clock_out_time
    return true if clock_out > clock_in

    errors['clock_out'] << 'cant be before clock-in time'
    false
  end

  def clock_in_now(now = nil)
    update_attributes(clock_in: now || Time.now)
  end

  def clock_out_now(now = nil)
    update_attributes(clock_out: now || Time.now)
  end
end
