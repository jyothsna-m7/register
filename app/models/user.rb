# frozen_string_literal: true
class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :events
  accepts_nested_attributes_for :events, allow_destroy: true

  def name=(value)
    return if value.nil?

    write_attribute(:name, value.downcase.squish)
  end
end
