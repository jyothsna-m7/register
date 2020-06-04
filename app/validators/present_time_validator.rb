# frozen_string_literal: true
class PresentTimeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value
    raise TypeError, "#{value} must of type Time" unless value.is_a?(Time)

    record.errors.add(attribute, 'cannot be in the future') if value > Time.now
  end
end
